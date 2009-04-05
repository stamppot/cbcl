require File.dirname(__FILE__) + '/../test_helper'

class GroupsTest < Test::Unit::TestCase #ActiveSupport::TestCase

  # fixtures :users
  # fixtures :roles
  # fixtures :roles_users
  # fixtures :groups
  # fixtures :groups_users

  def setup
  end
  
  def teardown
  end

  # teams parent and center are the same
  def test_teams_parent_are_center
    assert_equal @team101.center, @team101.parent
    assert_equal @team102.center, @team102.parent
    assert_equal @team201.center, @team201.parent
    assert_equal @team202.center, @team202.parent
  end
  
  def test_journals_have_center
    # journals in a team have the same parent as team
    assert_equal @journala_101.center, @team101.center
    assert_equal @journalb_102.center, @team102.center
    assert_equal @journale_201.center, @team201.center
    assert_equal @journalf_202.center, @team202.center

    # journals have a center
    assert_equal @journala_101.center, @center1
    assert_equal @journalb_102.center, @center1
    assert_equal @journale_201.center, @center2
    assert_equal @journalf_202.center, @center2
    
    # for journals in center (not team), their parent is this center
    assert_equal @journalc_1.parent, @center1
    assert_equal @journalc_1.center, @center1
    assert_equal @journald_2.parent, @center2
    assert_equal @journald_2.center, @center2
  end
  
  def test_center_journals
    # centers also have a journal in each team, and one which is not in a team
    assert_equal 3, @center1.journals.size
    assert_equal 3, @center2.journals.size
  end
  
  def test_team_access_to_journals
    # journal is in team, not in others 
    assert_equal @journala_101.parent, @team101
    assert_equal @journalb_102.parent, @team102
    assert_equal @journale_201.parent, @team201
    assert_equal @journalf_202.parent, @team202
    
    # these journal are in center, not in team
    assert_equal @journalc_1.parent, @center1
    assert_equal @journald_2.parent, @center2
  end
    
end
