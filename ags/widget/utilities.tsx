function format_string(format: string, data: any){
    return format.replace(/\{(\w+)\}/g, (_, key) => {
        return data[key];
    });
}
function format_percent(number: number, digits: number){
    let str = (parseFloat(number.toFixed(digits)) * 100).toString()
    if (str.length < digits) str += '.' + ('0'.repeat(digits - str.length))
    else if (str.length == digits) str += '0'
    else str = str.substring(0, Math.min(str.length, digits+1))
    return str
}

export{
    format_string,
    format_percent
}
