require "stripe"

Rails.configuration.stripe = {
  :publishable_key => ENV['pk_test_Hb7tkBbqJVS4SpmlLH6JKbOn'],
  :secret_key      => ENV['sk_test_2zAoySXFkpjLn2wxGw8ujRyu']
}
Stripe.api_key = "sk_test_2zAoySXFkpjLn2wxGw8ujRyu"
# Stripe.api_key = Rails.configuration.stripe[:secret_key]