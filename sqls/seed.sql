DROP TABLE IF EXISTS public.folders CASCADE;
CREATE TABLE public.folders (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100),
    position    INTEGER NOT NULL,
    parent_id   INTEGER DEFAULT NULL REFERENCES public.folders(id) ON DELETE CASCADE
);

CREATE INDEX folders_id_index        ON public.folders (id);
CREATE INDEX folders_position_index  ON public.folders (position);
CREATE INDEX folders_parent_id_index ON public.folders (parent_id);
