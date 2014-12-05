note
	project     : "Professional Developer’s Tool - DOSE 2014"
	description : "The main class of the project. It initializes the webframework and db object."
	author		: "Milan3 Team - Politecnico di Milano"
	email       : "se-dose-group8@lists.inf.ethz.ch"

class
	APPLICATION

inherit
	WSF_DEFAULT_SERVICE
		redefine
			initialize
		end

	WSF_ROUTED_SERVICE
		-- a routed_service implements the execute loop
		-- but it expectes us to implement

	WSF_URI_TEMPLATE_HELPER_FOR_ROUTED_SERVICE
		-- for the routing we use uri templates
		-- thus we can have "varialbes" in the uris

	LOG

create
	make_and_launch


feature {NONE} -- Initialization

	----------------------------------------------------------------------------
	------------- REMOVE THESE, ONLY FOR TESTING COMPILATION -------------------
	backlog : BACKLOG
	pbi : PBI
	sprintlog : SPRINTLOG
	task : TASK
	pdtdb : PDT_DB
	state : STATE
	------------- REMOVE PREVIOUS, ONLY FOR TESTING COMPILATION ----------------
	----------------------------------------------------------------------------

	rest_account             : REST_ACCOUNT
	rest_projects            : REST_PROJECTS
	rest_projects_pbis 	     : REST_PROJECTS_PBIS
	rest_projects_pbis_tasks : REST_PROJECTS_PBIS_TASKS
	rest_projects_sprintlogs : REST_PROJECTS_SPRINTLOGS
	rest_stats               : REST_STATS
	rest_chat                : REST_CHAT


	path_to_db_file: STRING
		-- calculates the path to the demo.db file, based on the location of the .ecf file
		-- Note: we used to have a fixed path here but this way it should work out-of-box for everyone
		once
			Result := ".." + Operating_environment.directory_separator.out + "pdt.db"
		end

	path_to_www_folder: STRING
		-- calculates the path to the www folder, based on the location of the .ecf file
		-- Note: we used to have a fixed path here but this way it should work out-of-box for everyone
		once
			Result := ".." + Operating_environment.directory_separator.out + "www"
		end

	session_manager: WSF_FS_SESSION_MANAGER


	initialize
			-- Initialize current service.
		local
		do
			log.info("Initializing...")
			-- Database initialization
			create pdtdb.make (path_to_db_file)

			-- Network initialization
			create session_manager.make
			create rest_account.make(session_manager, pdtdb)
			create rest_projects.make (session_manager, pdtdb)
			create rest_projects_pbis.make (session_manager, pdtdb)
			create rest_projects_pbis_tasks.make (session_manager, pdtdb)
			create rest_projects_sprintlogs.make (session_manager, pdtdb)
			create rest_stats.make (session_manager, pdtdb)

			set_service_option ("port", 8080)
			initialize_router

			log.info("Ready to serve.")

		end

feature -- Basic operations

	setup_router
		local
			fhdl: WSF_FILE_SYSTEM_HANDLER
		do
			-- List of accessible URL.
			-- PLEASE KEEP URL IN LESSICAL ORDER!
			map_uri_template_agent_with_request_methods ("/account/edit", agent rest_account.edit, router.methods_post)
			map_uri_template_agent_with_request_methods ("/account/langs", agent rest_account.langs, router.methods_get)
			map_uri_template_agent_with_request_methods ("/account/listdevelopers", agent rest_account.listdevelopers, router.methods_get)
			map_uri_template_agent_with_request_methods ("/account/login", agent rest_account.login_, router.methods_post)
			map_uri_template_agent_with_request_methods ("/account/logout", agent rest_account.logout_, router.methods_get)
			map_uri_template_agent_with_request_methods ("/account/register", agent rest_account.register, router.methods_post)
			map_uri_template_agent_with_request_methods ("/account/userinfo", agent rest_account.account_info, router.methods_get)

			map_uri_template_agent_with_request_methods ("/projects/list", agent rest_projects.listprojects, router.methods_get)
			map_uri_template_agent_with_request_methods ("/projects/create", agent rest_projects.create_project, router.methods_post)
			map_uri_template_agent_with_request_methods ("/projects/{idproj}/adddeveloper", agent rest_projects.adddeveloper, router.methods_post)
			map_uri_template_agent_with_request_methods ("/projects/{idproj}/remdeveloper", agent rest_projects.remdeveloper, router.methods_post)
			map_uri_template_agent_with_request_methods ("/projects/{idproj}/edit", agent rest_projects.editproject, router.methods_post)
			map_uri_template_agent_with_request_methods ("/projects/{idproj}/createbacklog", agent rest_projects.create_backlog, router.methods_post)

			map_uri_template_agent_with_request_methods ("/projects/{idproj}/pbis/create", agent rest_projects_pbis.create_pbi, router.methods_post)
			map_uri_template_agent_with_request_methods ("/projects/{idproj}/pbis/{idpbi}/delete", agent rest_projects_pbis.delete_pbi, router.methods_post)
			map_uri_template_agent_with_request_methods ("/projects/{idproj}/pbis/{idpbi}/edit", agent rest_projects_pbis.edit_pbi, router.methods_post)

			map_uri_template_agent_with_request_methods ("/projects/{idproj}/pbis/{idpbi}/createtask", agent rest_projects_pbis_tasks.createtask, router.methods_post)
			map_uri_template_agent_with_request_methods ("/projects/{idproj}/pbis/{idpbi}/listtasks", agent rest_projects_pbis_tasks.listtasks, router.methods_get)
			map_uri_template_agent_with_request_methods ("/projects/{idproj}/pbis/{idpbi}/tasks/{idtask}/delete", agent rest_projects_pbis_tasks.deletetask, router.methods_post)
			map_uri_template_agent_with_request_methods ("/projects/{idproj}/pbis/{idpbi}/tasks/{idtask}/edit", agent rest_projects_pbis_tasks.edittask , router.methods_post)

			map_uri_template_agent_with_request_methods ("/projects/{idproj}/sprintlogs/create", agent rest_projects_sprintlogs.createsprintlog, router.methods_post)
			map_uri_template_agent_with_request_methods ("/projects/{idproj}/sprintlogs/list", agent rest_projects_sprintlogs.listsprintlogs, router.methods_get)

			map_uri_template_agent_with_request_methods ("/stats/devpoints", agent rest_stats.devpoints, router.methods_get)

			-- setting the path to the folder from where we serve static files
			create fhdl.make_hidden (path_to_www_folder)
			fhdl.set_directory_index (<<"index.html">>)
			router.handle_with_request_methods ("", fhdl, router.methods_GET)
		end

end

