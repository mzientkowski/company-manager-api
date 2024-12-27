class FileImporter
  def initialize(file_parser)
    @file_parser = file_parser
  end

  def import
    unless file_parser.valid?
      errors.push(*file_parser.errors)
      return false
    end

    import_to_db
    @errors.nil?
  end

  def errors
    @errors ||= []
  end

  def imported_objects
    @imported_objects ||= []
  end

  private

  attr_reader :file_parser

  def import_to_db
    ActiveRecord::Base.transaction do
      file_parser.each do |obj|
        if obj.save
          imported_objects << obj
        else
          errors.push(*obj.errors)
          imported_objects.clear
          raise ActiveRecord::Rollback
        end
      end
    end
  end
end

