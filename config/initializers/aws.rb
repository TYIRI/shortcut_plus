creds = Aws::Credentials.new(
  Rails.application.credentials.aws[:access_key_id],
  Rails.application.credentials.aws[:secret_access_key]
  # ENV['AWS_ACCESS_KEY_ID'],
  # ENV['AWS_SECRET_ACCESS_KEY']
)

Aws::Rails.add_action_mailer_delivery_method(
  :aws_sdk,
  credentials: creds,
  region: 'ap-northeast-1'
)