const easymidi = require('easymidi');
const ipts = easymidi.getInputs();

easymidi.getInputs().forEach(
    (inputName) => {

        const input = new easymidi.Input(inputName);

        input.on(
            process.argv[2],
            (msg) => {
                let content = {
                    input: input.name,
                    event: process.argv[2],
                    msg: msg
                };
                console.log(JSON.stringify(content));
            }
        );
    })
