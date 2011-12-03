require 'spec_helper'

describe Explosion do
  it { should have_attached_file(:zipfile) }
  it { should validate_attachment_content_type(:zipfile).allowing('application/zip').rejecting('text/plain') }
  it { should validate_attachment_size(:zipfile).less_than(1.gigabytes) }

  it "build a state machine to manage the transitions through various phases of upload/processing?"
  it "should belong to the user who uploaded it"
end
