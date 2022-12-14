return {
  tag = 'input',
  summary = 'Animate a model to match its Device input state.',
  description = [[
    Animates a device model to match its current input state.  The buttons and joysticks on a
    controller will move as they're pressed/moved and hand models will move to match skeletal input.

    The model should have been created using `lovr.headset.newModel` with the `animated` flag set to
    `true`.
  ]],
  arguments = {
    device = {
      type = 'Device',
      default = [['head']],
      description = 'The device to use for the animation data.'
    },
    model = {
      type = 'Model',
      description = 'The model to animate.'
    }
  },
  returns = {
    success = {
      type = 'boolean',
      description = [[
        Whether the animation was applied successfully to the Model.  If the Model was not
        compatible or animation data for the device was not available, this will be `false`.
      ]]
    }
  },
  variants = {
    {
      arguments = { 'device', 'model' },
      returns = { 'success' }
    }
  },
  notes = [[
    Currently this function is only supported for hand models on the Oculus Quest.

    It's possible to use models that weren't created with `lovr.headset.newModel` but they need to
    be set up carefully to have the same structure as the models provided by the headset SDK.
  ]],
  related = {
    'lovr.headset.newModel'
  }
}
