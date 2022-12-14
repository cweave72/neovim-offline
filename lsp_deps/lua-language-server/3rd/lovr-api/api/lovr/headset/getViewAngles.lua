return {
  tag = 'headset',
  summary = 'Get the field of view angles of a view.',
  description = [[
    Returns the view angles of one of the headset views.

    These can be used with `Mat4:fov` to create a projection matrix.

    If tracking data is unavailable for the view or the index is invalid, `nil` is returned.
  ]],
  arguments = {
    view = {
      type = 'number',
      description = 'The view index.'
    }
  },
  returns = {
    left = {
      type = 'number',
      description = 'The left view angle, in radians.'
    },
    right = {
      type = 'number',
      description = 'The right view angle, in radians.'
    },
    top = {
      type = 'number',
      description = 'The top view angle, in radians.'
    },
    bottom = {
      type = 'number',
      description = 'The bottom view angle, in radians.'
    }
  },
  variants = {
    {
      arguments = { 'view' },
      returns = { 'left', 'right', 'top', 'bottom' }
    }
  },
  related = {
    'lovr.headset.getViewCount',
    'lovr.headset.getViewPose'
  }
}
