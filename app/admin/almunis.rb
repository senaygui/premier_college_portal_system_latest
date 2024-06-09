ActiveAdmin.register Almuni do
  menu parent: "Student managment"
  config.batch_actions = true

  permit_params :fullname,:sex,:phone_number,:modality,:study_level,:graduation_date,:program_name, :photo, documents: []
  active_admin_import

  # scoped_collection_action :scoped_collection_update, form: -> do
  #                                        { graduation_date: 'datepicker',
  #                                         created_at: 'datepicker',
  #                                         }
  #                                       end
  index do
    selectable_column
    column :fullname
    column :modality
    column :study_level
    column :program_name
    # column "Graduation Date", sortable: true do |c|
    #   c.graduation_date.strftime("%b %d, %Y")
    # end
    column "Created At", sortable: true do |c|
      c.created_at.strftime("%b %d, %Y")
    end
    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs "Almuni information" do
      div class: "avatar-upload" do
        div class: "avatar-edit" do
          f.input :photo, as: :file, label: "Upload Photo"
        end
        div class: "avatar-preview" do
          if f.object.photo.attached? 
            image_tag(f.object.photo,resize: '100x100',class: "profile-user-img img-responsive img-circle", id: "imagePreview")
          else
            image_tag("blank-profile-picture-973460_640.png",class: "profile-user-img img-responsive img-circle", id: "imagePreview")
          end
        end
      end
      f.input :fullname
      f.input :modality, as: :select, :collection => ["online", "regular", "extention", "distance"]
      f.input :study_level, as: :select, :collection => ["undergraduate", "graduate"]
      f.input :program_name
      f.input :sex, as: :select, :collection => ["Male", "Female"], :include_blank => false
      f.input :phone_number      
      f.input :graduation_date, as: :date_time_picker

    end
    f.actions
  end


  member_action :generate_tempo, method: :put do
    @almuni= Almuni.find(params[:id])
    @almuni.generate_qr
    redirect_back(fallback_location: admin_almuni_path)
  end
  action_item :update, only: :show do
    link_to 'generate tempo', generate_tempo_admin_almuni_path(almuni.id), method: :put, data: { confirm: 'Are you sure?' }        
  end

  show title: :fullname do
    panel "Almuni information" do
      attributes_table_for almuni do
        row "photo" do |pt|
          if pt.photo.present?
            span image_tag(pt.photo, size: '150x150', class: "img-corner") if almuni.photo.attached?
          end
        end
        row :fullname
        row :modality
        row :study_level
        row :program_name
        row :sex
        row :phone_number      
        row :graduation_date
        row :created_at
        row :updated_at
        row "QR code" do |pt|
          span link_to(image_tag(pt.qr_code), rails_blob_path(pt.qr_code, disposition: 'attachment')) if almuni.qr_code.attached?
        end
        row "Bar code" do |pt|
          link_to(image_tag(pt.barcode), pt.barcode) if almuni.barcode.attached?
        end
      end
    end
    render 'admin/print', context: self
  end
  
end
