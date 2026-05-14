require "net/http"
require "json"

module Community
  class ChatController < BaseController
    SYSTEM_PROMPT = <<~PROMPT.strip
      You are a helpful assistant for the Memphis Police Department's community portal.
      You help residents with questions about: how to report crimes, what number to call for
      emergencies vs non-emergencies, how to get a police report, what services the department
      offers, how to submit a tip, how to sign up for crime alerts, and other community safety
      topics. Be concise, friendly, and professional. Do not speculate about specific ongoing
      cases or release any sensitive information. If you don't know the answer, direct them
      to call the non-emergency line at (555) 555-0100.
    PROMPT

    def message
      user_message = params[:message].to_s.strip
      return render json: { error: "Message required" }, status: :bad_request if user_message.blank?
      return render json: { error: "Message too long" }, status: :bad_request if user_message.length > 1000

      api_key = ENV["ANTHROPIC_API_KEY"]
      unless api_key.present?
        render json: { reply: "The chatbot is not configured. Please call our non-emergency line at (555) 555-0100." }
        return
      end

      reply = call_anthropic(user_message, api_key)
      render json: { reply: reply }
    rescue => e
      render json: { reply: "Sorry, I'm having trouble right now. Please try again or call (555) 555-0100." }
    end

    private

    def call_anthropic(message, api_key)
      uri = URI("https://api.anthropic.com/v1/messages")
      req = Net::HTTP::Post.new(uri)
      req["Content-Type"]      = "application/json"
      req["x-api-key"]         = api_key
      req["anthropic-version"] = "2023-06-01"
      req.body = {
        model:      "claude-haiku-4-5-20251001",
        max_tokens: 512,
        system:     SYSTEM_PROMPT,
        messages:   [{ role: "user", content: message }]
      }.to_json

      Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, read_timeout: 15) do |http|
        response = http.request(req)
        data = JSON.parse(response.body)
        data.dig("content", 0, "text") || "I couldn't generate a response. Please call (555) 555-0100."
      end
    end
  end
end
