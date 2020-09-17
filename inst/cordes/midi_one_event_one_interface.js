const easymidi = require('easymidi');
const input = new easymidi.Input(process.argv[3]);

input.on(
    process.argv[2],
    (msg) => {
        let content = {
            input: input.name,
            event: event,
            msg: msg
        };
        console.log(JSON.stringify(content));
    }
);
