SELECT
  people.id,
  people.uuid,
  people.created_at,
  people.updated_at,
  people.is_admin,
  people.locale,
  people.preferences,
  people.active_days_count,
  people.last_page_load_date,
  people.test_group_number,
  people.username,
  people.reset_password_sent_at,
  people.remember_created_at,
  people.sign_in_count,
  people.current_sign_in_at,
  people.last_sign_in_at,
  people.given_name,
  people.family_name,
  people.display_name,
  people.phone_number,
  people.description,
  people.image_updated_at,
  emails.address AS email
FROM people
INNER JOIN emails
  ON emails.person_id = people.id
