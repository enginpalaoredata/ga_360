explore: page_facts {
  hidden: yes
}

view: page_facts {
  derived_table: {
    explore_source: ga_sessions {
      column: id {}
      column: full_visitor_id {}
      column: hit_id { field: hits.id }
      column: hit_time { field: hits.hit_time }
      column: hit_number {field:hits.hit_number}
      column: page_path { field: hits.page_path_formatted }
      derived_column: hit_sequence_number {sql:  ROW_NUMBER() OVER (PARTITION BY id ORDER BY hit_time ASC) ;;}
      derived_column: page_sequence_number {sql: ROW_NUMBER() OVER (PARTITION BY id ORDER BY hit_time ASC) ;;}
      derived_column: next_page_hit_number {sql: LEAD(hit_number) OVER (PARTITION BY id ORDER BY hit_time ASC) ;;}
      derived_column: current_page_minus_1 {sql: LAG(page_path) OVER (PARTITION BY id ORDER BY hit_time) ;;}
      derived_column: current_page_minus_2 {sql: LAG(page_path,2) OVER (PARTITION BY id ORDER BY hit_time) ;;}
      derived_column: current_page_minus_3 {sql: LAG(page_path,3) OVER (PARTITION BY id ORDER BY hit_time) ;;}
      derived_column: current_page_minus_4 {sql: LAG(page_path,4) OVER (PARTITION BY id ORDER BY hit_time) ;;}
      derived_column: current_page_minus_5 {sql: LAG(page_path,5) OVER (PARTITION BY id ORDER BY hit_time) ;;}
      derived_column: current_page_minus_6 {sql: LAG(page_path,6) OVER (PARTITION BY id ORDER BY hit_time) ;;}
      derived_column: cumulative_page_path {sql: STRING_AGG(page_path, " --> ") OVER (PARTITION BY id ORDER BY hit_time);;}
      filters: [hits.type: "PAGE", ga_sessions.partition_date: "@{PARTITION_DATE_PDT_FILTER}"]
    }
    persist_for: "24 hours"
  }

  ########## PRIMARY KEY ##########

  dimension: hit_id {
    hidden: yes
    description: "Unique Session ID | Hit Number"
    type: number
  }

  ########## FOREIGN KEYS ##########

  dimension: session_id {
    hidden: yes
    description: "Unique ID for Session: Full User ID | Session ID | Session Start Date"
    sql: ${TABLE}.id ;;
  }

  dimension: full_visitor_id {
    hidden: yes
    description: "The unique visitor ID (also known as client ID)."
  }

  ########## JOIN Fields #########

  dimension: hit_number {
    hidden: yes
    type: number
  }

  dimension: next_page_hit_number {
    hidden: yes
    description: "The hit number associated to the next PAGE hit based on the current page. Used to associate this table to all respective hits (i.e. EVENT and PAGE)."
    type: number
  }

  ########## DIMENSIONS ##########

  dimension: cumulative_page_path {
    view_label: "Session"
    group_label: "Pages Visited"
    description: "Cumulative page path to reach current page."
    type: string
    sql: ${TABLE}.cumulative_page_path ;;
  }

  dimension: current_page_minus_1 {
    view_label: "Page Flow"
    group_label: "Reverse Page Path"
    description: "Page Path for page that came directly before current page."
    type: string
  }
  dimension: current_page_minus_2 {
    view_label: "Page Flow"
    group_label: "Reverse Page Path"
    description: "Page Path for page that came 2 pages before current page."
    type: string
  }
  dimension: current_page_minus_3 {
    view_label: "Page Flow"
    group_label: "Reverse Page Path"
    description: "Page Path for page that came 3 pages before current page."
    type: string
  }
  dimension: current_page_minus_4 {
    view_label: "Page Flow"
    group_label: "Reverse Page Path"
    description: "Page Path for page that came 4 pages before current page."
    type: string
  }
  dimension: current_page_minus_5 {
    view_label: "Page Flow"
    group_label: "Reverse Page Path"
    description: "Page Path for page that came 5 pages before current page."
    type: string
  }
  dimension: current_page_minus_6 {
    view_label: "Page Flow"
    group_label: "Reverse Page Path"
    description: "Page Path for page that came 6 pages before current page."
    type: string
  }

  dimension: page_sequence_number {
    view_label: "Page Flow"
    description: "Sequenced page number in session."
    type: number
  }
}
