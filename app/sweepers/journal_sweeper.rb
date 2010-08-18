class JournalSweeper < ActionController::Caching::Sweeper
  observe Journal

  def after_save(journal)
    expire_cache(journal)
  end

  def after_destroy(journal)
    expire_cache(journal)
  end

  private

    def expire_cache(journal)
      expire_page journals_path 
      expire_page journal_path(journal)
    end

end