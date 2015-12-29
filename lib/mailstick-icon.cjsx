{React} = require 'nylas-exports'
{RetinaImg} = require 'nylas-component-kit'

class MailstickIcon extends React.Component
  @displayName: 'MailstickIcon'
  @propTypes: {}
  render: =>
    <RetinaImg url='nylas://mailstick/assets/mailstick@2x.png' mode={RetinaImg.Mode.ContentIsMask} />

module.exports = MailstickIcon
