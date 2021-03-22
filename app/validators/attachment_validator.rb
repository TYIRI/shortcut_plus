class AttachmentValidator < ActiveModel::EachValidator
  include ActiveSupport::NumberHelper

  def validate_each(record, attribute, value)
    return if value.blank? || !value.attached?

    has_error = false

    if options[:maximum]
      has_error = true unless validate_maximum(record, attribute, value)
    end

    if options[:content_type]
      has_error = true unless validate_content_type(record, attribute, value)
    end

    record.send(attribute).purge if options[:purge] && has_error
  end

  private

  def validate_maximum(record, attribute, value)
    attachments = value.is_a?(ActiveStorage::Attached::Many) ? value.attachments : [value.attachment]
    if attachments.any? { |attachment| attachment.byte_size > options[:maximum] }
      record.errors[attribute] << (options[:message] || "は#{number_to_human_size(options[:maximum])}以下にしてください")
      false
    else
      true
    end
    # if value.byte_size > options[:maximum]
    #   record.errors[attribute] << (options[:message] || "は#{number_to_human_size(options[:maximum])}以下にしてください")
    #   false
    # else
    #   true
    # end
  end

  def validate_content_type(record, attribute, value)
    attachments = value.is_a?(ActiveStorage::Attached::Many) ? value.attachments : [value.attachment]
    if attachments.any? { |attachment| attachment.content_type.match?(options[:content_type]) }
      true
    else
      record.errors[attribute] << (options[:message] || 'は対応できないファイル形式です')
      false
    end
    # if value.content_type.match?(options[:content_type])
    #   true
    # else
    #   record.errors[attribute] << (options[:message] || 'は対応できないファイル形式です')
    #   false
    # end
  end
end
