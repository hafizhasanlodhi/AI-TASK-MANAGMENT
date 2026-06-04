CREATE TABLE "calendar_items" (
	"id" serial PRIMARY KEY NOT NULL,
	"user_id" integer NOT NULL,
	"title" text NOT NULL,
	"description" text,
	"item_type" text DEFAULT 'task' NOT NULL,
	"category" text DEFAULT 'work' NOT NULL,
	"scheduled_date" text,
	"scheduled_time" text,
	"is_draft" boolean DEFAULT false NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "generated_apps" (
	"id" serial PRIMARY KEY NOT NULL,
	"user_id" integer NOT NULL,
	"app_name" text NOT NULL,
	"description" text NOT NULL,
	"icon" text DEFAULT 'LayoutTemplate' NOT NULL,
	"color" text DEFAULT '#F97316' NOT NULL,
	"layout" text DEFAULT 'single-page' NOT NULL,
	"definition" jsonb NOT NULL,
	"app_state" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"is_in_sidebar" boolean DEFAULT false NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "kanban_board_shares" (
	"id" serial PRIMARY KEY NOT NULL,
	"board_id" integer NOT NULL,
	"email" text NOT NULL,
	"role" text DEFAULT 'editor' NOT NULL,
	"invited_by_user_id" integer NOT NULL,
	"accepted_user_id" integer,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "kanban_boards" (
	"id" serial PRIMARY KEY NOT NULL,
	"user_id" integer NOT NULL,
	"name" text NOT NULL,
	"color" text DEFAULT 'sage' NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "kanban_columns" (
	"id" serial PRIMARY KEY NOT NULL,
	"board_id" integer NOT NULL,
	"name" text NOT NULL,
	"position" integer DEFAULT 0 NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "kanban_tasks" (
	"id" serial PRIMARY KEY NOT NULL,
	"column_id" integer NOT NULL,
	"title" text NOT NULL,
	"description" text,
	"due_date" text NOT NULL,
	"priority" text DEFAULT 'medium' NOT NULL,
	"category" text,
	"labels" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"sync_calendar" boolean DEFAULT false NOT NULL,
	"link_notes" boolean DEFAULT false NOT NULL,
	"calendar_item_id" integer,
	"position" integer DEFAULT 0 NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "notes" (
	"id" serial PRIMARY KEY NOT NULL,
	"user_id" integer NOT NULL,
	"title" text NOT NULL,
	"icon" text DEFAULT 'FileText' NOT NULL,
	"color" text DEFAULT 'sage' NOT NULL,
	"category" text,
	"content" jsonb NOT NULL,
	"plain_text" text DEFAULT '' NOT NULL,
	"word_count" integer DEFAULT 0 NOT NULL,
	"is_pinned" boolean DEFAULT false NOT NULL,
	"is_trashed" boolean DEFAULT false NOT NULL,
	"trashed_at" timestamp,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "page_comments" (
	"id" serial PRIMARY KEY NOT NULL,
	"page_id" integer NOT NULL,
	"user_id" integer,
	"body" text NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "page_task_links" (
	"id" serial PRIMARY KEY NOT NULL,
	"page_id" integer NOT NULL,
	"task_id" integer NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "space_pages" (
	"id" serial PRIMARY KEY NOT NULL,
	"space_id" integer NOT NULL,
	"title" text NOT NULL,
	"template" text DEFAULT 'Blank Page' NOT NULL,
	"page_type" text DEFAULT 'Document' NOT NULL,
	"description" text,
	"content" jsonb NOT NULL,
	"plain_text" text DEFAULT '' NOT NULL,
	"word_count" integer DEFAULT 0 NOT NULL,
	"is_favorite" boolean DEFAULT false NOT NULL,
	"is_archived" boolean DEFAULT false NOT NULL,
	"updated_by_user_id" integer,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "space_shares" (
	"id" serial PRIMARY KEY NOT NULL,
	"space_id" integer NOT NULL,
	"email" text NOT NULL,
	"role" text DEFAULT 'editor' NOT NULL,
	"invited_by_user_id" integer NOT NULL,
	"accepted_user_id" integer,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "spaces" (
	"id" serial PRIMARY KEY NOT NULL,
	"user_id" integer NOT NULL,
	"name" text NOT NULL,
	"description" text,
	"color" text DEFAULT 'violet' NOT NULL,
	"is_favorite" boolean DEFAULT false NOT NULL,
	"is_archived" boolean DEFAULT false NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "user_ai_usage" (
	"id" serial PRIMARY KEY NOT NULL,
	"user_id" integer NOT NULL,
	"usage_date" text NOT NULL,
	"action_count" integer DEFAULT 0 NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "user_categories" (
	"id" serial PRIMARY KEY NOT NULL,
	"user_id" integer NOT NULL,
	"scope" text NOT NULL,
	"name" text NOT NULL,
	"color" text DEFAULT '#5BAE91' NOT NULL,
	"icon" text DEFAULT 'Tag' NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "user_settings" (
	"id" serial PRIMARY KEY NOT NULL,
	"user_id" integer NOT NULL,
	"theme" text DEFAULT 'system' NOT NULL,
	"notifications_enabled" boolean DEFAULT true NOT NULL,
	"email_notifications_enabled" boolean DEFAULT false NOT NULL,
	"default_calendar_view" text DEFAULT 'month' NOT NULL,
	"default_task_priority" text DEFAULT 'medium' NOT NULL,
	"auto_save_enabled" boolean DEFAULT true NOT NULL,
	"privacy_mode_enabled" boolean DEFAULT false NOT NULL,
	"two_factor_reminder_dismissed" boolean DEFAULT false NOT NULL,
	"ai_model" text DEFAULT 'gemini-3.1-flash-lite' NOT NULL,
	"ai_behavior" text DEFAULT 'balanced' NOT NULL,
	"ai_tone" text DEFAULT 'Friendly' NOT NULL,
	"ai_refine_enabled" boolean DEFAULT true NOT NULL,
	"ai_assistant_enabled" boolean DEFAULT true NOT NULL,
	"ai_template_builder_enabled" boolean DEFAULT true NOT NULL,
	"ai_diagram_enabled" boolean DEFAULT true NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "user_settings_user_id_unique" UNIQUE("user_id")
);
--> statement-breakpoint
CREATE TABLE "users" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" text,
	"email" text NOT NULL,
	"liveblocks_id" text,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"clerk_id" text NOT NULL,
	CONSTRAINT "users_email_unique" UNIQUE("email"),
	CONSTRAINT "users_liveblocks_id_unique" UNIQUE("liveblocks_id"),
	CONSTRAINT "users_clerk_id_unique" UNIQUE("clerk_id")
);
--> statement-breakpoint
CREATE TABLE "whiteboards" (
	"id" serial PRIMARY KEY NOT NULL,
	"user_id" integer NOT NULL,
	"name" text NOT NULL,
	"color" text DEFAULT 'sage' NOT NULL,
	"scene" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"files" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
ALTER TABLE "calendar_items" ADD CONSTRAINT "calendar_items_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "generated_apps" ADD CONSTRAINT "generated_apps_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "kanban_board_shares" ADD CONSTRAINT "kanban_board_shares_board_id_kanban_boards_id_fk" FOREIGN KEY ("board_id") REFERENCES "public"."kanban_boards"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "kanban_board_shares" ADD CONSTRAINT "kanban_board_shares_invited_by_user_id_users_id_fk" FOREIGN KEY ("invited_by_user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "kanban_board_shares" ADD CONSTRAINT "kanban_board_shares_accepted_user_id_users_id_fk" FOREIGN KEY ("accepted_user_id") REFERENCES "public"."users"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "kanban_boards" ADD CONSTRAINT "kanban_boards_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "kanban_columns" ADD CONSTRAINT "kanban_columns_board_id_kanban_boards_id_fk" FOREIGN KEY ("board_id") REFERENCES "public"."kanban_boards"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "kanban_tasks" ADD CONSTRAINT "kanban_tasks_column_id_kanban_columns_id_fk" FOREIGN KEY ("column_id") REFERENCES "public"."kanban_columns"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "kanban_tasks" ADD CONSTRAINT "kanban_tasks_calendar_item_id_calendar_items_id_fk" FOREIGN KEY ("calendar_item_id") REFERENCES "public"."calendar_items"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notes" ADD CONSTRAINT "notes_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "page_comments" ADD CONSTRAINT "page_comments_page_id_space_pages_id_fk" FOREIGN KEY ("page_id") REFERENCES "public"."space_pages"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "page_comments" ADD CONSTRAINT "page_comments_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "page_task_links" ADD CONSTRAINT "page_task_links_page_id_space_pages_id_fk" FOREIGN KEY ("page_id") REFERENCES "public"."space_pages"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "page_task_links" ADD CONSTRAINT "page_task_links_task_id_kanban_tasks_id_fk" FOREIGN KEY ("task_id") REFERENCES "public"."kanban_tasks"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "space_pages" ADD CONSTRAINT "space_pages_space_id_spaces_id_fk" FOREIGN KEY ("space_id") REFERENCES "public"."spaces"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "space_pages" ADD CONSTRAINT "space_pages_updated_by_user_id_users_id_fk" FOREIGN KEY ("updated_by_user_id") REFERENCES "public"."users"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "space_shares" ADD CONSTRAINT "space_shares_space_id_spaces_id_fk" FOREIGN KEY ("space_id") REFERENCES "public"."spaces"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "space_shares" ADD CONSTRAINT "space_shares_invited_by_user_id_users_id_fk" FOREIGN KEY ("invited_by_user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "space_shares" ADD CONSTRAINT "space_shares_accepted_user_id_users_id_fk" FOREIGN KEY ("accepted_user_id") REFERENCES "public"."users"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "spaces" ADD CONSTRAINT "spaces_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_ai_usage" ADD CONSTRAINT "user_ai_usage_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_categories" ADD CONSTRAINT "user_categories_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_settings" ADD CONSTRAINT "user_settings_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "whiteboards" ADD CONSTRAINT "whiteboards_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "kanban_board_shares_board_email_unique" ON "kanban_board_shares" USING btree ("board_id","email");--> statement-breakpoint
CREATE UNIQUE INDEX "page_task_links_page_task_unique" ON "page_task_links" USING btree ("page_id","task_id");--> statement-breakpoint
CREATE UNIQUE INDEX "space_shares_space_email_unique" ON "space_shares" USING btree ("space_id","email");--> statement-breakpoint
CREATE UNIQUE INDEX "user_ai_usage_user_date_unique" ON "user_ai_usage" USING btree ("user_id","usage_date");--> statement-breakpoint
CREATE UNIQUE INDEX "user_categories_user_scope_name_unique" ON "user_categories" USING btree ("user_id","scope","name");