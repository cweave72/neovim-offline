return {
  tag = 'listener',
  summary = 'Set the position of the listener.',
  description = 'Sets the position of the virtual audio listener, in meters.',
  arguments = {
    x = {
      type = 'number',
      description = 'The x position of the listener.'
    },
    y = {
      type = 'number',
      description = 'The y position of the listener.'
    },
    z = {
      type = 'number',
      description = 'The z position of the listener.'
    }
  },
  returns = {},
  variants = {
    {
      arguments = { 'x', 'y', 'z' },
      returns = {}
    }
  }
}
