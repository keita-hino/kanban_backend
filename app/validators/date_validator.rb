# frozen_string_literal: true

class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # 日付型は不正な値を入れるとnilになり date: { allow_blank: true } としてもバリデーションが走らない
    # そのための対策としてオプションに presence: true を入れる事で対応
    # return if options[:presence].blank? || options[:presence] == false

    if value.blank? && record.send("#{attribute}_before_type_cast").blank?
      record.errors[attribute] << I18n.t('errors.messages.blank')
      return
    end

    value = value.to_s unless value.is_a?(String)
    value = value.gsub('/', '-')
    record.errors[attribute] << I18n.t('errors.messages.invalid_date') unless /\A\d{1,4}-\d{1,2}-\d{1,2}\Z/ =~ value

    begin
      (y, m, d) = value.split('-')
      Time.zone.local(y, m, d, 0, 0, 0)
    rescue StandardError
      record.errors[attribute] << I18n.t('errors.messages.invalid_date')
    end
  end
end
