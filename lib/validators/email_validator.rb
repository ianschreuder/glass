class EmailValidator < ActiveModel::EachValidator

  EMAIL_REGEX = /\A[\w\.%\+\-\']+@(?:[A-Z0-9\-]+\.)+(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|jobs|museum)\z/i

  def validate_each(record, attribute, value)
    if value.blank?
      record.errors[attribute] << (options[:message] || "You must provide an email")
      return
    end
    
    record.errors[attribute] << (options[:message] || "Email too short") if value.length < 3
    record.errors[attribute] << (options[:message] || "Email too long") if value.length > 254
    record.errors[attribute] << (options[:message] || "Email is already in use") if record.new_record? && User.find_by_email(value).present?
    record.errors[attribute] << (options[:message] || "Email is a bad format") unless value =~ EMAIL_REGEX
  end

end
