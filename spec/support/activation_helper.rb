module ActivationHelpers
  def activate(user)
    user.update(activation_state: 'active', activation_token: nil, activation_token_expires_at: nil)
  end
end
