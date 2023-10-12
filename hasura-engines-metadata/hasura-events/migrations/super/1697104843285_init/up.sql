SET check_function_bodies = false;
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';
CREATE FUNCTION public.update_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;
CREATE TABLE public.beer (
    beer_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    style character varying(255),
    brewery_id uuid,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);
CREATE TABLE public.brewery (
    brewery_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    location character varying(255),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);
CREATE TABLE public.customers (
    customer_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255),
    phone_number character varying(20),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);
CREATE TABLE public.employee_details (
    employee_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid,
    role_id uuid,
    hire_date date,
    salary numeric(12,2),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);
CREATE TABLE public.employee_roles (
    role_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    role_name character varying(255) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);
CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);
CREATE TABLE public.inventory (
    inventory_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    beer_id uuid,
    quantity integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);
CREATE TABLE public.orders (
    order_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    customer_name character varying(255) NOT NULL,
    order_date date,
    beer_id uuid,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);
CREATE TABLE public.suppliers (
    supplier_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    contact_person character varying(255),
    email character varying(255),
    phone_number character varying(20),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);
CREATE TABLE public.transactions (
    transaction_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    transaction_date date,
    description text,
    amount numeric(10,2),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);
CREATE TABLE public.users (
    user_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    username character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);
ALTER TABLE ONLY public.beer
    ADD CONSTRAINT beer_pkey PRIMARY KEY (beer_id);
ALTER TABLE ONLY public.brewery
    ADD CONSTRAINT brewery_pkey PRIMARY KEY (brewery_id);
ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);
ALTER TABLE ONLY public.employee_details
    ADD CONSTRAINT employee_details_pkey PRIMARY KEY (employee_id);
ALTER TABLE ONLY public.employee_roles
    ADD CONSTRAINT employee_roles_pkey PRIMARY KEY (role_id);
ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);
ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (inventory_id);
ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);
ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (supplier_id);
ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transaction_id);
ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);
CREATE TRIGGER beer_updated_trigger BEFORE UPDATE ON public.beer FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();
CREATE TRIGGER brewery_updated_trigger BEFORE UPDATE ON public.brewery FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();
CREATE TRIGGER customers_updated_trigger BEFORE UPDATE ON public.customers FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();
CREATE TRIGGER employee_details_updated_trigger BEFORE UPDATE ON public.employee_details FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();
CREATE TRIGGER employee_roles_updated_trigger BEFORE UPDATE ON public.employee_roles FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();
CREATE TRIGGER inventory_updated_trigger BEFORE UPDATE ON public.inventory FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();
CREATE TRIGGER orders_updated_trigger BEFORE UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();
CREATE TRIGGER suppliers_updated_trigger BEFORE UPDATE ON public.suppliers FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();
CREATE TRIGGER transactions_updated_trigger BEFORE UPDATE ON public.transactions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();
CREATE TRIGGER users_updated_trigger BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();
ALTER TABLE ONLY public.beer
    ADD CONSTRAINT beer_brewery_id_fkey FOREIGN KEY (brewery_id) REFERENCES public.brewery(brewery_id);
ALTER TABLE ONLY public.employee_details
    ADD CONSTRAINT employee_details_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.employee_roles(role_id);
ALTER TABLE ONLY public.employee_details
    ADD CONSTRAINT employee_details_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);
ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_beer_id_fkey FOREIGN KEY (beer_id) REFERENCES public.beer(beer_id);
ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_beer_id_fkey FOREIGN KEY (beer_id) REFERENCES public.beer(beer_id);
