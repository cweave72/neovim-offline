return {
  summary = 'Get the seed value of the RandomGenerator.',
  description = 'Returns the seed used to initialize the RandomGenerator.',
  arguments = {},
  returns = {
    low = {
      type = 'number',
      description = 'The lower 32 bits of the seed.'
    },
    high = {
      type = 'number',
      description = 'The upper 32 bits of the seed.'
    }
  },
  variants = {
    {
      arguments = {},
      returns = { 'low', 'high' }
    }
  },
  notes = [[
    Since the seed is a 64 bit integer, each 32 bits of the seed are returned separately to avoid
    precision issues.
  ]],
  related = {
    'lovr.math.newRandomGenerator'
  }
}
