module ActiveRecord

  module ProjectApproval

    def self.included(base)

      base.const_set 'STATUS_WAITING_FOR_APPROVAL', 2

      base.before_create do |record|
        record.status = base::STATUS_WAITING_FOR_APPROVAL unless User.current.admin
      end

      base.after_create do |record|
        if record.status = base::STATUS_WAITING_FOR_APPROVAL
          admin = User.find(:first, :conditions => { :admin => true })
          ApprovalNotifier.deliver_waiting_for_approval(admin, record)
        end
      end

      base.after_save do |record|
        record.users.each { |user| ApprovalNotifier.deliver_project_has_been_approved(user, record) } if record.changes['status'] == [2, 1]
      end
    end

  end

end