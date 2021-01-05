function convertBr(str) {
    return str.replace(/<br>/g, '\n').replace(/<br\/>/g, '\n');
}