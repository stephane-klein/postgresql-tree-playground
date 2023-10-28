WITH _folder AS (
     SELECT path
       FROM public.ltree_folders
      WHERE id=1 -- <= id of "folder_a"
      LIMIT 1
 )
 SELECT
     id,
     name
 FROM
     public.ltree_folders
 WHERE
     (path <@ (SELECT path FROM _folder)) AND
     (path <> (SELECT path FROM _folder));
