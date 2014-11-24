SELECT query1.repository_url as repo1, query2.repository_url as repo2, COUNT(query1.user) AS weight
  FROM
    -- identical query 1
    (
      SELECT user, repo_info.repository_url as repository_url
        FROM
          (
            SELECT repo_last_events.repository_url as repository_url
              FROM
                (
                  SELECT repository_url, MAX(created_at) as created_at
                    FROM [githubarchive:github.timeline]
                    WHERE PARSE_UTC_USEC(created_at) >= PARSE_UTC_USEC('2012-01-01 00:00:00')
                      AND PARSE_UTC_USEC(created_at) < PARSE_UTC_USEC('2012-04-01 00:00:00')
                    GROUP EACH BY repository_url
                ) AS repo_last_events
                
                JOIN EACH 
                (
                  SELECT repository_url, repository_watchers, created_at
                    FROM [githubarchive:github.timeline]
                    WHERE repository_watchers >= 1000
                ) AS repo_filter_by_watchers
                
                ON repo_last_events.repository_url = repo_filter_by_watchers.repository_url
                  AND repo_last_events.created_at = repo_filter_by_watchers.created_at
          ) AS repo_info
          
          JOIN EACH
          (
            SELECT repository_url, actor AS user
              FROM [githubarchive:github.timeline]
              WHERE PARSE_UTC_USEC(created_at) >= PARSE_UTC_USEC('2012-01-01 00:00:00')
                AND PARSE_UTC_USEC(created_at) < PARSE_UTC_USEC('2012-04-01 00:00:00')
                AND type = 'WatchEvent'
              GROUP EACH BY repository_url, user
          ) AS events
          
          ON repo_info.repository_url = events.repository_url
        GROUP EACH BY repository_url, user
    ) AS query1
  
    JOIN EACH 
    -- identical query 2
    (
      SELECT user, repo_info.repository_url as repository_url
        FROM
          (
            SELECT repo_last_events.repository_url as repository_url
              FROM
                (
                  SELECT repository_url, MAX(created_at) as created_at
                    FROM [githubarchive:github.timeline]
                    WHERE PARSE_UTC_USEC(created_at) >= PARSE_UTC_USEC('2012-01-01 00:00:00')
                      AND PARSE_UTC_USEC(created_at) < PARSE_UTC_USEC('2012-04-01 00:00:00')
                    GROUP EACH BY repository_url
                ) AS repo_last_events
                
                JOIN EACH 
                (
                  SELECT repository_url, repository_watchers, created_at
                    FROM [githubarchive:github.timeline]
                    WHERE repository_watchers >= 1000
                ) AS repo_filter_by_watchers
                
                ON repo_last_events.repository_url = repo_filter_by_watchers.repository_url
                  AND repo_last_events.created_at = repo_filter_by_watchers.created_at
          ) AS repo_info
          
          JOIN EACH
          (
            SELECT repository_url, actor AS user
              FROM [githubarchive:github.timeline]
              WHERE PARSE_UTC_USEC(created_at) >= PARSE_UTC_USEC('2012-01-01 00:00:00')
                AND PARSE_UTC_USEC(created_at) < PARSE_UTC_USEC('2012-04-01 00:00:00')
                AND type = 'WatchEvent'
              GROUP EACH BY repository_url, user
          ) AS events
          
          ON repo_info.repository_url = events.repository_url
        GROUP EACH BY repository_url, user
    ) AS query2
    ON query1.user = query2.user
  WHERE query1.repository_url < query2.repository_url
  GROUP EACH BY repo1, repo2
  
