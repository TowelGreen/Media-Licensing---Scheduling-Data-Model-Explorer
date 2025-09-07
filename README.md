# Media Licensing & Scheduling Data Model Explorer  

This project demonstrates how to design and query a **relational database schema** for managing **media licensing and scheduling**. It simulates real-world challenges faced by media companies, including **platform exclusivity, overlapping schedules, licensing restrictions, and metadata tagging**.  

## Key Contributions  

- **Designed a normalized schema** with entities for Media, Platforms, Licenses, Schedules, and Tags (genre, rating, language, release year).  
- **Implemented conflict detection queries** to identify overlapping schedules and exclusivity violations across platforms.  
- **Built a metadata tagging system** enabling rich, flexible queries (e.g., filter by genre + rating + platform).  
- **Documented business use cases** to connect technical queries with real-world media scheduling challenges.  

##  Example Queries  

- **Overlapping Schedules** – Detect double-bookings on the same platform.  
- **Exclusivity Conflicts** – Find media licensed as "exclusive" but scheduled across multiple platforms.  
- **Metadata Filtering** – Retrieve media by tag combinations (e.g., *PG-13 comedies released after 2015*).
- **Muti region detection** - Find which media is streaming in differect regions at the same time  

##  Tech Stack  

- **SQL** – Schema design & queries  
- **MySql** – Relational database engines  
- **Markdown** – Documentation  

##  Business Impact  

This model shows how **media companies can ensure compliance, prevent scheduling conflicts, and leverage metadata for content discovery**. It demonstrates skills in:  

- **Database schema design** (normalization, many-to-many relationships)  
- **Query logic for conflict detection**  
- **Business-driven data modeling**  
