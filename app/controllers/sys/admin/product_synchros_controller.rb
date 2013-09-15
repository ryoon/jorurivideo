# encoding: utf-8
class Sys::Admin::ProductSynchrosController < Sys::Admin::ProductSynchros::BaseController

protected
  def post_sync_user(saved, pre_user_attrs, user, pre_group_attrs, group, options={} )
    if saved
      # update video clip creator info
      synchronize_clips pre_user_attrs, user
    end
  end


  def post_sync( options={} )
    # before destory
    user = Sys::User.new
    user.and :ldap, 1
    user.and :ldap_version, 'IS', nil
    users = user.find(:all, :select => "id")

    clear_creator_info users
  end


private
  def synchronize_clips(pre_user_attrs, user)
    clip  = Video::Clip.new
    clip.and :creator_id, pre_user_attrs['id']
    clips = clip.find(:all)

    if clips && clips.size > 0
      creator_group = Video::Base::UsersGroup.find(:first, :conditions => {:user_id => user.id } )

      clips.each do |c|
        unless  creator_group
          if c.shared?
            c.creator_id = nil
          else
            # TODO: to shared ?
            # org.editting_state = 'shared'
          end
        else
          # exist
          if creator_group.group_id != c.creator_group_id || creator_group.group_id.to_s != c.editting_group_ids
            if c.shared?
              c.creator_id = nil
            else
              c.creator_group_id   = creator_group.group_id
              c.editting_group_ids = creator_group.group_id.to_s
            end
          end
        end
        begin
          Video::Clip.record_timestamps = false  # no update timestamps(created_at, updated_at)
          if c.save(:validate => false)
            @results[:product] += 1
          else
            @results[:perr] += 1
          end
          Video::Clip.record_timestamps = true   # active update timestamps
        rescue
           @results[:perr] += 1
        end if c.changed?
      end
    end
  end

  def clear_creator_info(users)
    users.each do |u|
      clip  = Video::Clip.new
      clip.and :creator_id, u['id']
      clip.find(:all).each do |c|
        if c.shared?
          c.creator_id = nil
        else
          # TODO: to shared ?
          # org.editting_state = 'shared'
        end
        begin
          Video::Clip.record_timestamps = false  # no update timestamps(created_at, updated_at)
          if c.save(:validate => false)
            @results[:product] += 1
          else
            @results[:perr] += 1
          end
          Video::Clip.record_timestamps = true   # active update timestamps
        rescue
           @results[:perr] += 1
        end if c.changed?
      end
    end
  end

end
