class FileImporter
  def initialize(import_obj, file_parser)
    @import_obj= import_obj
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

  attr_reader :file_parser, :import_obj

  def import_to_db
    ActiveRecord::Base.transaction do
      file_parser.each do |obj|
        obj.import_id = import_obj.id
        if obj.save
          imported_objects << obj
        else
          errors << obj.errors
          imported_objects.clear
          raise ActiveRecord::Rollback
        end
      end
    end
  end
end
