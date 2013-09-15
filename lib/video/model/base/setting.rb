# encoding: utf-8
module Video::Model::Base::Setting

  def self.included(mod)

  end

  def setting(config_name=nil, options={})
    _user_id = self.creator_id
    _user_id = Core.user.id if _user_id.blank? && Core && Core.user

    _u = Video::Base::User.new
    _u.and 'id', _user_id
    @user = _u.find(:first)

    return Video::AdminSetting.config(config_name) if (_user_id.blank? || !@user) && options[:admin_setting] == true && config_name

    return nil unless _user_id
    return nil unless @user

    s = nil
    s = Video::Setting.config(@user, config_name, {:instance => false}) if config_name
    return s if s && !s.value.blank?
    return Video::AdminSetting.config(config_name) if options[:admin_setting] == true && config_name
    return nil
  end

  def settings
    return Video::Setting.configs(@user) if @user
    return nil unless @user = Video::Base::User.find(Core.user.id)
    return Video::Setting.configs(@user)
  end

  def initiarize_settings(properties=[],  options={})
    properties.each do |p|
      if Video::Setting === p
      elsif Video::AdminSetting === p
        # admin setting
        #maximum_file_size(p.value) if defined?(maximum_file_size) && p.name == 'maximum_file_size'

        if defined?(upper_limit_file_size) && p.name == 'upper_limit_file_size'
          upper_limit_file_size(p.value)
        elsif defined?(maximum_file_size) && p.name == 'maximum_file_size'
          maximum_file_size(p.value)
        elsif defined?(set_maximum_frame_size) && p.name == 'maximum_frame_size'
          set_maximum_frame_size(p.value)
        elsif defined?(maximum_duration) && p.name == 'maximum_duration'
          maximum_duration(p.value)
        elsif defined?(maximum_monthly_report_count) && p.name == 'maximum_monthly_report_count'
          maximum_monthly_report_count(p.value)
        end
      else
        # throw
      end

    end
  end

end
