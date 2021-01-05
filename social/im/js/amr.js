(function (global) {
	global.util = {
		toString: function (data, fn) {
			var BlobBuilder = global["WebKitBlobBuilder"] || global["MozBlobBuilder"] || global["BlobBuilder"];

			var bb = new BlobBuilder();
			bb.append(data.buffer);
			buffer = null;
			var reader = new FileReader();
			reader.onload = function (e) {
				fn(e.target.result);
			};
			reader.readAsBinaryString(bb.getBlob());	
		}

	  , parseInt: function (chr) {
	  		return Binary.toUint8(chr);
	  	}

	  , mozPlay: function (floats) {
		  	var audio, pos = 0, size;
		  	if ((audio = new Audio())["mozSetup"]) {
		  		audio.mozSetup(1, 8000);

		  		while (pos < floats.length) {
		  			size = (floats.length - pos > 800) ? 800 : floats.length - pos;
		  			audio.mozWriteAudio(floats.subarray(pos, pos+size));
		  			pos += size;
		  		}  		
		  	}
		}

	  , play: function (floats) {
		  	var waveData = PCMData.encode({
				sampleRate: 8000,
				channelCount:   1,
				bytesPerSample: 2,
				data: floats
			});
			
			var element = new Audio();
			element.src = "data:audio/wav;base64,"+btoa(waveData);
			element.play();	
		}

		/**
		  * @author LearnBoost
		  */
	  , merge: function (target, additional, deep, lastseen) {
			var seen = lastseen || []
			  , depth = typeof deep == 'undefined' ? 2 : deep
			  , prop;

			for (prop in additional) {
			  if (additional.hasOwnProperty(prop) && seen.indexOf(prop) < 0) {
			    if (typeof target[prop] !== 'object' || !depth) {
			      target[prop] = additional[prop];
			      seen.push(additional[prop]);
			    } else {
			      merge(target[prop], additional[prop], depth - 1, seen);
			    }
			  }
			}

			return target;
		}

		/**
		  * @author LearnBoost
		  */
	  , inherit: function (ctor, ctor2) {
	    	function f() {};
	    	f.prototype = ctor2.prototype;
	    	ctor.prototype = new f;
	  	}
  	}
}(this));

(function (global) {

function AMR(params) {
	!params && (params = {});
	this.params = params;

	this.frame_size = 320 || params.frame_size;

	this.ring_size = 2304 || params.ring_size;
	
  this.linoffset = 0;

  this.ringoffset = 0;

  this.modoffset = 0;
    
  this.linbuf = new Int16Array(this.frame_size);

  this.ring = new Int16Array(this.ring_size * 2);

  this.modframes = new Int16Array(this.frame_size);
  
  this.framesbuf = [];
	
	this.decoder = new AMRDecoder(params);
	this.encoder = new AMREncoder(params);	

	this.init();
}

AMR.util = global.util;

AMR.prototype.init = function () {	
	this.encoder.init();
	this.decoder.init();
}

AMR.prototype.set = function (name, value) {	
	this.options[name] = value;
}

AMR.prototype.enable = function (option) {	
	this.set(option, true);
}

AMR.prototype.disable = function (option) {	
	this.set(option, false);
}

/**
  * Initialize the codec
  */
AMR.prototype.init = function () {	
	this.encoder.init();
	this.decoder.init();
}

/**
  * @argument pcmdata Float32Array|Int16Array
  * @returns String|Uint8Array
  */
AMR.prototype.encode = function (data, isFile) {
	isFile = !!isFile;

	if (isFile) {
		return this.encoder.process(data);
	}

	// ring spin
    for (var i=-1, j=this.ringoffset; ++i < data.length; ++j) {
        this.ring[j] = data[i];
    }
    
    this.ringoffset += data.length;

    // has enough to decode
    if ((this.ringoffset > this.linoffset) 
    	&& (this.ringoffset - this.linoffset < this.frame_size)) {
        
        return;
    }

    // buffer fill
    for (var i=-1; ++i < this.linbuf.length;) {
        this.linbuf[i] = this.ring[this.linoffset + i];            
    }

    this.linoffset += this.linbuf.length;
    this.framesbuf = this.encoder.process(this.linbuf);

    if (this.ringoffset > this.ring_size) {
        this.modoffset = this.ringoffset % this.ring_size;
        
        //console.log("ignoring %d samples", this.modoffset);
        this.ringoffset = 0;
    }

    if (this.linoffset > this.ring_size) {
        this.linoffset = 0;
    }

    return this.framesbuf;
}

/**
  * @argument encoded String|Uint8Array
  * @returns Float32Array
  */
AMR.prototype.decode = function (bitstream) {
	return this.decoder.process(bitstream);
}

/**
  * Closes the codec
  */
AMR.prototype.close = function () {
	this.encoder.close();
	this.decoder.close();
}

AMR.onerror = function (message, code) {
	console.error("AMR Error "+code+": "+message);
}

util.merge(AMR, {
	MAGIC_NUMBER: [35, 33, 65, 77, 82, 10]
  , MAGIC_NUMBER_STRING: "#!AMR\n"
  
  	/** Decoding modes and its frame sizes (bytes), respectively */
  , modes: {
		0: 12
	  , 1: 13
	  ,	2: 15
	  ,	3: 17
	  , 4: 19
	  , 5: 20
	  , 6: 26
	  , 7: 31
	  , 8:  5
	}
});

global.AMR = AMR;
}(this));

(function (global) {

var util = AMR.util;


function AMREncoder(options) {
	this.params = options;
	
	this.mode = options.mode || 5; // MR795 by default

	this.frame_size = 160;

	this.block_size = AMR.modes[this.mode];

	this.dtx = (options.dtx + 0) || 0;
}

AMREncoder.prototype.init = function () {
	var options = this.options;
	var ptr = opencoreamr.allocate(1, 'i32', opencoreamr.ALLOC_STACK), ret, encSize;

	/* Create Encoder */
	this.state = opencoreamr.Encoder_Interface_init(this.dtx);

	this.input = opencoreamr.allocate(this.frame_size, 'i16', opencoreamr.ALLOC_STATIC);	
	this.buffer = opencoreamr.allocate(this.block_size, 'i8', opencoreamr.ALLOC_STATIC);
}

/**
  * Copy the samples to the input buffer
  */
AMREncoder.prototype.read = function (offset, length, data) {
	var input_addr = this.input
	  , len = offset + length > data.length ? data.length - offset : length;

	for (var m=offset-1, k=0; ++m < offset+len; k+=2){
		opencoreamr.setValue(input_addr+k, data[m], 'i16');
	}

	return len;
}

AMREncoder.prototype.writeMagicNumber = function () {
	for (var i=-1; ++i<6; ) {
		this.output[i] = AMR.MAGIC_NUMBER[i];
	}
}

/* Copy to the output buffer */
AMREncoder.prototype.write = function (offset, nb, addr) {	
	var bits;
  	for (var m=0, k=offset-1; ++k<offset+nb; m+=1) {
  		bits = opencoreamr.getValue(addr+m, "i8");
  		this.output[k] = bits;
  	}  	
}

AMREncoder.prototype.process = function (pcmdata) {
	//benchmark && console.time('encode');
	var output_offset = 0, offset = 0, len, nb, err, tm_str
	  , benchmark = !!this.benchmark	  
	  , total_packets = Math.ceil(pcmdata.length / this.frame_size)
	  , estimated_size = this.block_size * total_packets
	  , buffer_len_ptr = opencoreamr.allocate(1, 'i32', opencoreamr.ALLOC_STACK);

	if (!this.output || this.output.length < estimated_size) {
		this.output = new Uint8Array(estimated_size + 6);
	}

	this.writeMagicNumber();
	output_offset += 6;

	var bits_addr = this.bits
	  , input_addr = this.input
	  , buffer_addr = this.buffer
	  , state_addr = this.state;
	
	while (offset < pcmdata.length) {
		//benchmark && console.time('encode_packet_offset_'+offset);
		
		/* Frames to the input buffer */
		len = this.read(offset, this.frame_size, pcmdata);	
		
    	/* Encode the frame */
    	nb = opencoreamr.Encoder_Interface_Encode(this.state, this.mode
	    	, input_addr, buffer_addr, 0);

    	/* Write the size and frame */
    	this.write(output_offset, nb, buffer_addr);

    	benchmark && console.timeEnd('encode_packet_offset_'+offset);

    	output_offset += nb;
    	offset += len;
	}

	benchmark && console.timeEnd('encode');

	return this.output.subarray(0, output_offset);
}


AMREncoder.prototype.close = function () {
	opencoreamr.Encoder_Interface_exit(this.state);
}

global["AMREncoder"] = AMREncoder;

}(this));
/**
  * Different modes imply different block sizes:
  * modes = MR475, MR515, MR59, MR67, MR74, MR795, MR102, MR122, MRSID
  * indexes =   0,     1,    2,    3,    4,     5,     6,     7,     8
  * bits =     12, 	  13,   15,   17,   19,    20,    26,    31,     5
  * samples =  160
  */
function AMRDecoder(options) {
	this.params = options;

	this.block_size = 20;
	this.frame_size = 160;
}

AMRDecoder.prototype.init = function () {	
	var options = this.options;	
	
	/* Create decoder */
	this.state = opencoreamr.Decoder_Interface_init();

	// 'XXX' - change to parameters

	// Input Buffer
    this.input = opencoreamr.allocate(20, 'i8', opencoreamr.ALLOC_STATIC);
	
	// Buffer to store the audio samples
    this.buffer = opencoreamr.allocate(160, 'i16', opencoreamr.ALLOC_STATIC);
}

AMRDecoder.prototype.validate = function (magic) {
	var is_str = magic.constructor == String;
	if (is_str) {
		return (magic === "#!AMR\n");
	}

	for (var i = -1; ++i<6; ) {
		if (magic[i] != AMR.MAGIC_NUMBER[i]){
			return false
		}
	}
	
	return true;
}

/**
  * Copy the samples to the input buffer
  */
AMRDecoder.prototype.read = function (offset, data) {
	// block_size = 31 ==> [mode(1):frames(30)]
	var is_str = data.constructor == String.prototype.constructor;
	var dec_mode = is_str ? Binary.toUint8(data[0]) : data[0];
	
	var nb = AMR.modes[(dec_mode >> 3) & 0x000F];
	var input_addr = this.input
	  , len = offset + nb > data.length ? data.length - offset : nb
	  , bits;

	for (var m=offset-1, k=0; ++m < offset+len; k+=1){
		bits = !is_str ? data[m] : Binary.toUint8(data[m]);
		opencoreamr.setValue(input_addr+k, bits, 'i8');
	}

	return len;
}


AMRDecoder.prototype.process = function (data) {
	var is_str = data.constructor == String
	  , head = is_str ? data.substring(0, 6) : data.subarray(0, 6);

	if (!this.validate(head)) {
		return;
	}

	data = is_str ? data.substr(6) : data.subarray(6);
	//benchmark && console.time('decode');
	var output_offset = 0, offset = 0, len;

	// Varies from quality
	var total_packets = Math.ceil(data.length / this.block_size)
	  , estimated_size = this.frame_size * total_packets
	  , benchmark = !!this.params.benchmark
	  , tot = 0;
	
	var input_addr = this.input
	  , buffer_addr = this.buffer
	  , state_addr = this.state;
		
	if (!this.output || this.output.length < estimated_size) {
		this.output = new Float32Array(estimated_size);		
	}
	
	while (offset < data.length) {	
		/* Benchmarking */
		//benchmark && console.time('decode_packet_offset_' + offset);

		/* Read bits */
		len = this.read(offset, data);

  		/* Decode the data */
  		opencoreamr.Decoder_Interface_Decode(state_addr, input_addr, buffer_addr, 0);

  		/* Write the samples to the output buffer */
  		this.write(output_offset, this.frame_size, buffer_addr);

  		/* Benchmarking */
  		//benchmark && console.timeEnd('decode_packet_offset_' + offset);

  		offset += len + 1;
  		output_offset += this.frame_size;
  		++tot;
  	}

  	//benchmark && console.timeEnd('decode');
  	return this.output.subarray(0, output_offset);
}

/**
  * Copy to the output buffer 
  */
AMRDecoder.prototype.write = function (offset, nframes, addr) {	
	var bits;
  	for (var m=0, k=offset-1; ++k<offset+nframes; m+=2) {
		bits = opencoreamr.getValue(addr+m, "i16");
  		this.output[k] = bits / 32768;
  	}
}

AMRDecoder.prototype.close = function () {	
	opencoreamr.Decoder_Interface_exit(this.state);
}

AMRDecoder.Files = {
    base64ToBlob: function(base64Data, mimeType) {
        if (mimeType) {
            mimeType = { type: mimeType };
        }
        base64Data = this.trimBase64(base64Data);
        var sliceSize = 1024;
        var byteCharacters = atob(base64Data);
        var bytesLength = byteCharacters.length;
        var slicesCount = Math.ceil(bytesLength / sliceSize);
        var byteArrays = new Array(slicesCount);

        for (var sliceIndex = 0; sliceIndex < slicesCount; ++sliceIndex) {
            var begin = sliceIndex * sliceSize;
            var end = Math.min(begin + sliceSize, bytesLength);
            var bytes = new Array(end - begin);
            for (var offset = begin, i = 0 ; offset < end; ++i, ++offset) {
                bytes[i] = byteCharacters[offset].charCodeAt(0);
            }
            byteArrays[sliceIndex] = new Uint8Array(bytes);
        }
        return new Blob(byteArrays, mimeType);
    },
    trimBase64: function(base64Str) {
        return base64Str.replace(/^(.*)[,]/, '');
    }
};

window.handleFileSelect=function(base64Data) {
    var blob=AMRDecoder.Files.base64ToBlob(base64Data,"audio/amr");
    var reader = new FileReader();
	reader.onload =function(){
        var samples = new AMR({
            benchmark: true
        }).decode(reader.result);
        AMR.util.play(samples);
    };
    reader.readAsBinaryString(blob);
}