class CharactersController < ApplicationController
  before_filter do |controller|
    controller.restrict_access(3)
  end

  def new
    @character = Character.new

    respond_to do |format|
      format.html { render 'race_select', :layout => 'blank' }
    end
  end

  def edit
    @character = Character.find(params[:id])
    if @character.character_character_classes.empty?
      view = 'class_select'
      @character.character_character_classes.build
    elsif !@character.attributes_selected?
      view = 'attribute_select'
    elsif @character.last_created_class.completed_selection
      view = 'sheet'
    else
      view = 'edit_class_options'
      @selected_class_relation = @character.last_created_class
    end

    respond_to do |format|
      format.html { render view, :layout => 'blank' }
    end
  end

  # Creates a character after the race has been selected.
  def create
    @character = Character.new(params[:character])
    @character.user_id = current_user.id
    params[:success] = @character.save

    respond_to do |format|
      format.js { render :next_step }
    end
  end

  def update
    @character = Character.find(params[:id])
    params[:success] = @character.update_attributes(params[:character])
    params[:view] ||= :update

    respond_to do |format|
      format.js { render params[:view] }
    end
  end

  def destroy_attributes_selection
    @character = Character.find(params[:id])
    @character.attributes_selected = false
    params[:success] = @character.save

    respond_to do |format|
      format.js { render :next_step }
    end
  end

  def update_attributes_selection
    @character = Character.find(params[:id])
    unless params[:arbitrary_attribute].nil?
      params[:character][params[:arbitrary_attribute].to_sym] = (params[:character][params[:arbitrary_attribute].to_sym].to_i + 2).to_s
    end

    @character.race.race_attributes.each do |r_a|
      attr = r_a.attribute.name.downcase.to_sym
      params[:character][attr] = (params[:character][attr].to_i + r_a.value).to_s
    end

    params[:success] = @character.update_attributes(params[:character])

    respond_to do |format|
      format.js { render :next_step }
    end
  end

  def destroy_class_selection
    @character = Character.find(params[:id])
    @character.last_created_class.destroy

    render :nothing => true
  end

  def update_class_options
    @character = Character.find(params[:id])
    params[:success] = @character.last_created_class.update_attributes(params[:character_character_class])

    respond_to do |format|
      format.js { render :next_step }
    end
  end

	active_scaffold :character do |config|
    config.actions.exclude :show, :create, :update
    config.list.columns = [:name, :race, :character_classes, :level, :adventure]
    config.search.columns = [:name]

    config.columns[:adventure].clear_link
    config.columns[:race].clear_link
    config.columns[:character_classes].clear_link

    config.action_links.add :new, :label => I18n.t('active_scaffold.create_new'), :page => true, :type => :collection,
                            :html_options => CharactersHelper::lightview_options

    config.action_links.add :edit, :label => I18n.t('active_scaffold.edit'), :page => true, :type => :member,
                            :html_options => CharactersHelper::lightview_options
  end

  protected

  def conditions_for_collection
    ['characters.user_id = ?', current_user.id]
  end
end
