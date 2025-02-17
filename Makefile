up:
	OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES rails s

swag:
	bundle exec rake rswag:specs:swaggerize

console:
	bundle exec rails c

test:
	bundle exec rspec spec

test_u:
	UPDATE_SNAPSHOTS=true bundle exec rspec spec

annotate:
	bundle exec annotaterb models

bundle_audit:
	bundle exec rake bundle:audit

rubocop:
	bundle exec rubocop

brakeman:
	bundle exec brakeman

reek:
	bundle exec reek

fasterer:
	bundle exec fasterer
