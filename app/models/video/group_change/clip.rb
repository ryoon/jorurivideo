# encoding: utf-8
class Video::GroupChange::Clip < Sys::GroupChangeItem

  belongs_to :entity,   :foreign_key => :item_id,      :class_name => 'Video::Clip'

  def entity_cls_name
    Video::Clip.name
  end


  def pull(change, setting)
      # find all clips
      clip = Video::Clip.new
      clip.order "creator_id, creator_group_id, editting_group_ids"
      clips = clip.find(:all)

      targets   = []

      clips.each do |c|
        # creator_idがsys_users_groupsにあるかどうか、無い場合変換対象（ステータス：ユーザ削除） ※空で所属動画の場合はスルー
        creator_group = Video::Base::UsersGroup.find(:first, :conditions => {:user_id => c.creator_id } )
        unless creator_group
          unless c.creator_id.blank? && c.shared?
            targets << c
            next
          end

        else
          # ユーザがいた場合、そのユーザのグループとcreator_group_id、editting_group_idsと等しいかどうか、等しくない場合変換対象（ステータス：所属差異）
          unless creator_group.group_id == c.creator_group_id
            targets << c
            next
          end
          # TODO:現状、editting_group_idsに複数グループがあった場合の対応はできていない
          unless creator_group.group_id.to_s == c.editting_group_ids
            targets << c
            next
          end
        end

        # creator_group_id、editting_group_idsがsys_groupsにあるかどうか、無い場合変換対象（ステータス：グループ削除）
        unless c.creator_group
          targets << c
          next
        end

        unless editting_group = Video::Base::Group.find(:first, :conditions => { :id => c.editting_group_ids } )
          targets << c
          next
        end
      end
      transcribe_data targets, { :skip_unid => true }
  end


  def synchronize(changes, setting)
    self.class.find(:all, :conditions => { :model => entity_cls_name }).each do |temp|
      if org = temp.entity
        # update creator_id, creator_group_id、editting_group_ids

        creator_group = Video::Base::UsersGroup.find(:first, :conditions => {:user_id => org.creator_id } )
        unless  creator_group
          if org.shared?
            org.creator_id = nil
          else
            # TODO: to shared ?
            # org.editting_state = 'shared'
          end

        else
          # exist
          if creator_group.group_id != org.creator_group_id || creator_group.group_id.to_s != org.editting_group_ids
            if org.shared?
              org.creator_id = nil
            else
              org.creator_group_id   = creator_group.group_id
              org.editting_group_ids = creator_group.group_id.to_s
            end
          end
        end

        # group change
        unless org.creator_group
          change_groups = Sys::GroupChange.find(:all, :conditions => {:old_id => org.creator_group_id})
          change_groups.each do |cg|
            if cg.change_division == 'dismantle'
              if commutation_g = cg.commutation_group
                org.creator_group_id = commutation_g.id
              end
            elsif current_group = cg.group
              org.creator_group_id   = current_group.id
            end
          end
        end
        unless editting_group = Video::Base::Group.find(:first, :conditions => { :id => org.editting_group_ids } )
          change_groups = Sys::GroupChange.find(:all, :conditions => {:old_id => org.editting_group_ids})
          change_groups.each do |cg|
            if cg.change_division == 'dismantle'
              if commutation_g = cg.commutation_group
                org.editting_group_ids = commutation_g.id.to_s
              end
            elsif current_group = cg.group
              org.editting_group_ids = current_group.id.to_s
            end
          end
        end
        begin
          #org.save(false)
          Video::Clip.record_timestamps = false  # no update timestamps(created_at, updated_at)
          org.save(:validate => false)
          Video::Clip.record_timestamps = true   # active update timestamps
        rescue
          #dump org.attributes
        end if org.changed?
      end
    end
  end

end