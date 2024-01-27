use ig_clone

select * from users

-- 1. Create an ER diagram or draw a schema for the given database.
-- Please find the answer in the attached screenshot
--------------------------------------------------------------------------------------------

-- 2. We want to reward the user who has been around the longest, Find the 5 oldest users.

select * from users order by created_at asc
limit 5

------------------------------------------------------------------------------------------------------

-- 3.To target inactive users in an email ad campaign, find the users who have never posted a photo.

-- Using joins

select u.id, u.username from users u left join photos p 
on u.id= p.user_id
where p.id is null;

-- By using non related sub query

select * from users where id not in (select user_id from photos);
----------------------------------------------------------------------------------------------------------

-- 4.Suppose you are running a contest to find out who got the most likes on a photo. Find out who won?

select * from likes
select * from photos

select u.username,p.id,count(l.user_id) as most_liked from photos p
inner join likes l
on p.id=l.photo_id
inner join users u
 on p.user_id= u.id
 group by p.id
 order by most_liked desc
 
 limit 1
 -----------------------------------------------------------------------------------------------------
 
 -- 5. The investors want to know how many times does the average user post.
 
 (select count(*) from photos)
 (select count(*) from users)
 
 select ceil((select count(*) from photos)/(select count(*) from users)) as Avg_posts_user
 
 
 ----------------------------------------------------------------------------------------------------
 -- 6. A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags.
 
 -- By using joins 

 select t.tag_name, count(*) as total
 from tags t inner join photo_tags pt
 on t.id=pt.tag_id  
 group by t.id
 order by total desc 
 limit 5 ;
 
 
 -- By using sub queries 

select tag_id, tag_name, total
from (
  select tag_id, count(*) as total
  from photo_tags
 group by tag_id) as pt
inner join tags on pt.tag_id = tags.id
order by total desc
limit 5;
 
 
------------------------------------------------------------------------------------
-- 7.To find out if there are bots, find users who have liked every single photo on the site.

-- select count(*) from photos 
-- using joins

select u.username,u.id , count(*) as total_likes from users u 
inner join likes l 
on u.id=l.user_id 
group by l.user_id 
having total_likes = (select count(*) from photos);

-- using cte's 

with user_likes as 
   (select user_id, count(*) as total_likes
    from likes
    group by user_id),
photos_count as
    (select count(*) as total_photos
    from photos)
select u.username, u.id, ul.total_likes
from users u
inner join user_likes ul on u.id = ul.user_id
inner join photos_count pc ON ul.total_likes = pc.total_photos;

--------------------------------------------------------------------------------
-- 8. Find the users who have created instagramid in may and select top 5 newest joinees from it?

-- if need to find top 5 joinees in only may month

select * from users where monthname(created_at) = 'May' 
order by created_at desc
limit 5

-- if top 5 from all the users then 

select * from users
order by created_at desc
limit 5

-------------------------------------------------------------------------------------------------------------

/* 9. Can you help me find the users whose name starts with c and ends with any number and have posted the photos as well as 
   liked the photos? */
   
 -- using joins
 select distinct u.* from users u inner join photos p   
 on u.id = p.user_id inner join likes l   
 on p.id= l.photo_id     
 where u.username regexp "^c.*[0-9]$" 
 
 -- using sub queries  -- corelated sub query
 
select distinct u.* from users u inner join photos p   
 on u.id = p.user_id inner join likes l   
 on p.id= l.photo_id 
 where u.id in ( select u.id from users u 
    where u.username regexp "^c.*[0-9]$")

------------------------------------------------------------------------------------------------------------------------

-- 10. Demonstrate the top 30 usernames to the company who have posted photos in the range of 3 to 5.

select u.id, u.username, count(p.id) as total_photos from users u 
inner join photos p 
on u.id = p.user_id
group by  u.id
having total_photos = 3 or total_photos=4 or total_photos=5
order by total_photos desc
limit 30











