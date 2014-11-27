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
			map_uri_template_agent_with_request_methods ("/account/langs", agent rest_account.langs, router.methods_get)
			map_uri_template_agent_with_request_methods ("/account/listdevelopers", agent rest_account.listdevelopers, router.methods_get)
			map_uri_template_agent_with_request_methods ("/account/login", agent rest_account.login_, router.methods_post)
			map_uri_template_agent_with_request_methods ("/account/logout", agent rest_account.logout_, router.methods_get)
			map_uri_template_agent_with_request_methods ("/account/register", agent rest_account.register, router.methods_post)
			map_uri_template_agent_with_request_methods ("/account/userinfo", agent rest_account.account_info, router.methods_get)

			-- setting the path to the folder from where we serve static files
			create fhdl.make_hidden (path_to_www_folder)
			fhdl.set_directory_index (<<"index.html">>)
			router.handle_with_request_methods ("", fhdl, router.methods_GET)
		end

end

