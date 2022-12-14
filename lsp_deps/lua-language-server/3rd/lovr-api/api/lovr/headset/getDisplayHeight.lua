return {
  tag = 'headset',
  summary = 'Get the height of the headset display.',
  description = 'Returns the height of the headset display (for one eye), in pixels.',
  arguments = {},
  returns = {
    height = {
      type = 'number',
      description = 'The height of the display.'
    }
  },
  variants = {
    {
      arguments = {},
      returns = { 'height' }
    }
  },
  related = {
    'lovr.headset.getDisplayWidth',
    'lovr.headset.getDisplayDimensions'
  }
}
