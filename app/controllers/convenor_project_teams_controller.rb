class ConvenorProjectTeamsController < ApplicationController
  def index
    @project_template = ProjectTemplate.includes(:task_templates).find(params[:id])
    
    @projects = Project.includes({
                  team_membership: [:user, :team],
                  tasks: [:task_template]
                  }, :project_template
                )
                .where(project_template_id: params[:id])

    @projects.sort!{|a,b| a.team_membership.user.name <=> b.team_membership.user.name }

    @project_teams = @projects.map {|project|
      project.team_membership.team
    }.uniq
  end

  def show
    @project_template = ProjectTemplate.find(params[:project_template_id])
    @team             = Team.find(params[:team_id])
  end
end