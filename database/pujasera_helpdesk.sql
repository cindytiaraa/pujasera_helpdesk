CREATE TABLE public.users (
  id text NOT NULL,
  name text NOT NULL,
  email text NOT NULL UNIQUE,
  phone text,
  role text NOT NULL,
  department text,
  avatar text,
  password text NOT NULL,
  code text NOT NULL DEFAULT ''::text UNIQUE,
  CONSTRAINT users_pkey PRIMARY KEY (id)
);
CREATE TABLE public.tickets (
  id text NOT NULL,
  title text NOT NULL,
  description text,
  category text,
  priority text,
  status text,
  user_id text,
  assigned_to_id text,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone DEFAULT now(),
  location text,
  current_stage text DEFAULT 'Ticket berhasil dibuat'::text,
  code text NOT NULL DEFAULT ''::text UNIQUE,
  image_url text,
  CONSTRAINT tickets_pkey PRIMARY KEY (id),
  CONSTRAINT fk_tickets_user FOREIGN KEY (user_id) REFERENCES public.users(id),
  CONSTRAINT fk_tickets_assigned FOREIGN KEY (assigned_to_id) REFERENCES public.users(id)
);
CREATE TABLE public.comments (
  id text NOT NULL,
  ticket_id text,
  user_id text,
  user_name text,
  role text,
  text text,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT comments_pkey PRIMARY KEY (id),
  CONSTRAINT fk_comments_ticket FOREIGN KEY (ticket_id) REFERENCES public.tickets(id),
  CONSTRAINT fk_comments_user FOREIGN KEY (user_id) REFERENCES public.users(id)
);
CREATE TABLE public.notifications (
  id text NOT NULL,
  ticket_id text,
  target_user_id text,
  title text,
  message text,
  type text,
  is_read boolean DEFAULT false,
  created_at timestamp without time zone DEFAULT now(),
  CONSTRAINT notifications_pkey PRIMARY KEY (id),
  CONSTRAINT fk_notifications_ticket FOREIGN KEY (ticket_id) REFERENCES public.tickets(id),
  CONSTRAINT fk_notifications_user FOREIGN KEY (target_user_id) REFERENCES public.users(id)
);
CREATE TABLE public.ticket_history (
  id text NOT NULL,
  ticket_id text NOT NULL,
  actor_id text,
  status text NOT NULL,
  title text NOT NULL,
  description text,
  location text,
  actor_name text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT ticket_history_pkey PRIMARY KEY (id),
  CONSTRAINT fk_ticket_history_ticket FOREIGN KEY (ticket_id) REFERENCES public.tickets(id),
  CONSTRAINT fk_ticket_history_actor FOREIGN KEY (actor_id) REFERENCES public.users(id)
);
CREATE TABLE public.ticket_reports (
  id text NOT NULL,
  ticket_id text NOT NULL,
  resolved_by text,
  resolution text,
  resolution_note text,
  duration_minutes integer,
  customer_rating integer,
  customer_feedback text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT ticket_reports_pkey PRIMARY KEY (id),
  CONSTRAINT fk_ticket_report_ticket FOREIGN KEY (ticket_id) REFERENCES public.tickets(id),
  CONSTRAINT fk_ticket_report_user FOREIGN KEY (resolved_by) REFERENCES public.users(id)
);