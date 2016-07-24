extractor = /^([^# ]{1,})\s{1,}([^# ]{1,})/

module.exports = ()->
    (input='')->
        output = {}
        for line in input.split('\n')
            match = line.trim().match(extractor)
            if match
                output[match[1]] = match[2]
        return output
