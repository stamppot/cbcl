require File.dirname(__FILE__) + '/../test_helper'

class UserGroupsTest < ActiveSupport::TestCase #ActiveSupport::TestCase

  def setup
  end
  
  def teardown
  end

  #test if @users are in a team
  def test_user_team_access
    # @user in @team101 cannot access team 102
    assert_include @team101, @user1_101.teams
    assert_not_include @team102, @user2_101.teams
    
    assert_include @team102, @user1_102.teams
    assert_not_include @team201, @user2_102.teams
    assert_not_include @team202, @user2_102.teams
    
    # no access to teams across centers
    assert_none(@user1_101.teams, @center2.teams)
    assert_none(@user1_102.teams, @center2.teams)
    assert_none(@user1_201.teams, @center1.teams)
    assert_none(@user1_202.teams, @center1.teams)
    
    # same for center 2
    # user in center2:team201 can access own team, but not other team in same center
    assert_include @team201, @user1_201.teams
    assert_not_include @team202, @user2_201.teams
    assert_include @team202, @user1_202.teams
    assert_not_include @team201, @user2_202.teams
    
    # @users in center 2 cannot access teams in center 1
    assert_include @team101, @user1_101.teams
    assert_not_include @team102, @user2_201.teams
  end

  # user in team has access to journal
  def test_user_access_to_journals
    # both users in team has access to journal
    assert_include @journala_101, @user1_101.journals
    assert_include @journala_101, @user2_101.journals
    assert_not_include @journalb_102, @user1_101.journals
    assert_not_include @journalb_102, @user2_101.journals
    # users in other teams have no access
    assert_not_include @journala_101, @user1_102.journals
    assert_not_include @journala_101, @user2_102.journals
    # no access to center journal
    assert_not_include @journalc_1, @user1_102.journals  # center-journals are not accessible by users with team access only
    
    # users in other center do not have access to journals in first center 
    assert_include @journale_201, @user1_201.journals
    assert_include @journale_201, @user2_201.journals
    assert_include @journalf_202, @user2_202.journals
    # users in other teams have no access
    assert_not_include @journale_201, @user1_202.journals
    assert_not_include @journalf_202, @user2_201.journals
    assert_not_include @journald_2, @user2_201.journals  # center-journals are not accessible by users with team access only
  end

  # test if @users are in a center
  def test_user_has_correct_center
    # team 101
    assert_equal @center1, @user1_101.center
    assert_equal @center1, @user2_101.center
    # team 102
    assert_equal @center1, @user1_102.center
    assert_equal @center1, @user2_102.center
    # user from center1 cannot access center 2
    assert_not_equal @center2, @user1_101.center
    assert_not_equal @center2, @user2_101.center
    assert_not_equal @center2, @user1_102.center
    assert_not_equal @center2, @user2_102.center

    assert_equal @center2.title, @user1_201.center.title
    assert_equal @center2, @user2_201.center
    assert_equal @center2, @user1_202.center
    assert_equal @center2, @user2_202.center

    assert_not_equal @center1, @user1_201.center
    assert_not_equal @center1, @user2_201.center
    assert_not_equal @center1, @user1_202.center
    assert_not_equal @center1, @user2_202.center
  end
  
  def test_team_users
    assert_equal 2, @team101.users.size
    assert_equal 2, @team102.users.size
    assert_equal 2, @team201.users.size
    assert_equal 2, @team202.users.size
    # centers also have a centeradmin
    assert_equal 6, @center1.users.size
    assert_equal 6, @center2.users.size
  end

  def test_user_have_center
    assert_equal @center1, @user1_101.center
    assert_equal @center1, @user2_101.center
    assert_equal @center1, @user1_102.center
    assert_equal @center1, @user2_102.center
    assert_equal @center2, @user1_201.center
    assert_equal @center2, @user2_201.center
    assert_equal @center2, @user1_202.center
    assert_equal @center2, @user2_202.center
  end

  # application controller uses journal_ids to check access
  def test_access_journals
    # test for roles centeradmin, admin, superadmin
    assert_all @user_admin.journals.map(&:id), @user_admin.journal_ids
    assert_all @user_superadmin.journals.map(&:id), @user_superadmin.journal_ids

    
    assert_all @user1_101.journals.map(&:id), @user1_101.journal_ids
    assert_all @user2_101.journals.map(&:id), @user2_101.journal_ids
    assert_all @user1_102.journals.map(&:id), @user1_102.journal_ids
    assert_all @user2_102.journals.map(&:id), @user2_102.journal_ids
    # none of the other journal_ids
    assert_none @user1_101.journals.map(&:id), @user1_102.journal_ids
    assert_none @user1_101.journals.map(&:id), @user1_201.journal_ids
    assert_none @user1_101.journals.map(&:id), @user2_202.journal_ids

    assert_none @user1_102.journals.map(&:id), @user1_101.journal_ids
    assert_none @user1_102.journals.map(&:id), @user1_201.journal_ids
    assert_none @user1_102.journals.map(&:id), @user2_202.journal_ids

    assert_none @user1_201.journals.map(&:id), @user1_102.journal_ids
    assert_none @user1_201.journals.map(&:id), @user1_101.journal_ids
    assert_none @user1_201.journals.map(&:id), @user2_202.journal_ids

    assert_none @user1_202.journals.map(&:id), @user1_102.journal_ids
    assert_none @user1_202.journals.map(&:id), @user1_201.journal_ids
    assert_none @user1_202.journals.map(&:id), @user2_102.journal_ids

    # for another user in center 2
    assert_all @user1_201.journals.map(&:id), @user1_201.journal_ids
    assert_all @user2_201.journals.map(&:id), @user2_201.journal_ids
    assert_all @user1_202.journals.map(&:id), @user1_202.journal_ids
    assert_all @user2_202.journals.map(&:id), @user2_202.journal_ids
    # none of the other journal_ids
    assert_none @user1_201.journals.map(&:id), @user1_102.journal_ids
    assert_none @user1_201.journals.map(&:id), @user1_101.journal_ids
    assert_none @user1_201.journals.map(&:id), @user2_202.journal_ids

    assert_none @user1_202.journals.map(&:id), @user1_101.journal_ids
    assert_none @user1_202.journals.map(&:id), @user1_201.journal_ids
    assert_none @user1_202.journals.map(&:id), @user2_102.journal_ids
  end
  
  def test_center_and_teams_depend_on_role
    # for normal user, returns only teams
    assert @user1_101.has_role?(:behandler)
    assert !@user1_101.has_role?(:centeradministrator)
    assert_all @user1_101.center_and_teams, @user1_101.teams
    # for center admin, returns both teams and center
    assert_all @user_center1.center_and_teams, (@user_center1.teams << @user_center1.center)
  end

  def test_journal_entry_ids_match_journal_entries
    # used for access control
    entries = @user1_101.journals(:per_page => 100000).map {|j| j.journal_entries }.flatten.map(&:id)
    assert_all entries, @user1_101.journal_entry_ids
  end
end
