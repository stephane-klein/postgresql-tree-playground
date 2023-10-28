-- parent_id implementation

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

-- ltree implementation

CREATE EXTENSION IF NOT EXISTS ltree;

DROP TABLE IF EXISTS public.ltree_folders CASCADE;
CREATE TABLE public.ltree_folders (
    id          SERIAL PRIMARY KEY,
    path        LTREE,
    name        VARCHAR(100)
);

CREATE INDEX ltree_folders_id_index         ON public.ltree_folders (id);
CREATE INDEX ltree_folders_path_gist_index  ON public.ltree_folders USING GIST (path);
CREATE INDEX ltree_folders_path_btree_index ON public.ltree_folders USING BTREE (path);
