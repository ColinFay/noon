const easymidi = require('easymidi');
const ipts = easymidi.getInputs();

easymidi.getInputs().forEach(
    (inputName) => {

        const input = new easymidi.Input(inputName);

        const events = [
            'noteoff',
            'noteon',
            'poly aftertouch',
            'cc',
            'program',
            'channel aftertouch',
            'pitch',
            'position',
            'select',
            'start',
            'continue',
            'stop',
            'reset'
        ];

        if (process.argv[2] === '1') {
            events.push('clock');
        }

        events.forEach(
            (event) => {
                input.on(
                    event,
                    (msg) => {
                        let content = {
                            input: input.name,
                            event: event,
                            msg: msg
                        };
                        console.log(JSON.stringify(content));
                    }
                );
            })
    })
