class RollbackTransaction < ActiveRecord::Migration
  def rollback
604:       execute "rollback transaction"
605:       @transaction_active = false
606:       true
607:     end
end
