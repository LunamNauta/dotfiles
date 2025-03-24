const userOptions = {
    time: {
        interval: 1000,
        format: '%H:%M:%S'
    },
    uptime: {
        interval: 1000,
        format: 'Uptime {uptime_hours}h, {uptime_minutes}m'
    },
    date: {
        interval: 1000,
        format: '%A, %e/%m'
    },
    cpu:{
        interval: 1000,
        format: "{cpu}%"
    },
    memory: {
        interval: 1000,
        format: "{mem}%"
    }
}

export{
    userOptions
}
