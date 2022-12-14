return {
  summary = 'Add a new control point to the Curve.',
  description = 'Inserts a new control point into the Curve at the specified index.',
  arguments = {
    x = {
      type = 'number',
      description = 'The x coordinate of the control point.'
    },
    y = {
      type = 'number',
      description = 'The y coordinate of the control point.'
    },
    z = {
      type = 'number',
      description = 'The z coordinate of the control point.'
    },
    index = {
      type = 'number',
      default = 'nil',
      description = [[
        The index to insert the control point at.  If nil, the control point is added to the end of
        the list of control points.
      ]]
    }
  },
  returns = {},
  variants = {
    {
      arguments = { 'x', 'y', 'z', 'index' },
      returns = {}
    }
  },
  notes = [[
    An error will be thrown if the index is less than one or more than the number of control points.
  ]],
  related = {
    'Curve:getPointCount',
    'Curve:getPoint',
    'Curve:setPoint',
    'Curve:removePoint'
  }
}
