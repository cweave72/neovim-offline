return {
  summary = 'Set the Shape\'s position.',
  description = 'Set the position of the Shape relative to its Collider.',
  arguments = {
    x = {
      type = 'number',
      description = 'The x offset.'
    },
    y = {
      type = 'number',
      description = 'The y offset.'
    },
    z = {
      type = 'number',
      description = 'The z offset.'
    }
  },
  notes = 'If the Shape isn\'t attached to a Collider, this will error.',
  returns = {},
  variants = {
    {
      arguments = { 'x', 'y', 'z' },
      returns = {}
    }
  },
  related = {
    'Shape:getOrientation',
    'Shape:setOrientation'
  }
}
