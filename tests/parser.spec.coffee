parserFactory = require(APP_ROOT + '/src/parser')

describe 'Parser', ()->
    beforeEach ->
        @parser = parserFactory()
        @input = """
        # this is a comment
         #this is a comment with space
        arm_solution                                 linear_delta

        #
        arm_length                                   250.0            # this is the length of an arm from hinge to hinge
        arm_radius                                   124.0            # this is the horizontal distance from hinge to hinge when the effector is centered
        """
        return

    describe 'Empty string/null/undefined input', ()->

        it 'Should not throw an error', ()->
            expect(=>@parser('')).to.not.throw(Error)
            expect(=>@parser()).to.not.throw(Error)
            expect(=>@parser(null)).to.not.throw(Error)

        it 'Should be parsed to empty object', ()->
            res = @parser('')
            expect(res).to.be.a('object')
            expect(Object.keys(res).length).to.equal(0)

    describe 'Proper configuration', ()->

        it 'Should not throw an error', ()->
            expect(=>@parser(@input)).to.not.throw(Error)

        it 'Should skip lines if empty and comments', ()->
            expect(Object.keys(@parser(@input)).length).to.equal(3)

        it 'Should return all configuration optiions with proper values', ()->
            res = @parser(@input)

            expect(res).to.have.property('arm_solution', 'linear_delta')
            expect(res).to.have.property('arm_length', '250.0')
            expect(res).to.have.property('arm_radius', '124.0')
