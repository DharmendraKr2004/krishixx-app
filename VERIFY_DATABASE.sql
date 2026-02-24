-- ============================================
-- QUICK VERIFICATION QUERIES
-- Run these in Supabase SQL Editor to check if data exists
-- ============================================

-- 1. Check if table exists
SELECT EXISTS (
   SELECT FROM information_schema.tables 
   WHERE table_schema = 'public' 
   AND table_name = 'cropdata'
);
-- Expected: true

-- 2. Count total records
SELECT COUNT(*) as total_records FROM public.cropdata;
-- Expected: 290+ records

-- 3. Count crops
SELECT COUNT(DISTINCT "Crop") as total_crops FROM public.cropdata;
-- Expected: 35 crops

-- 4. List all crop names
SELECT DISTINCT "Crop" FROM public.cropdata ORDER BY "Crop";
-- Expected: Banana, Bitter Gourd, Bottle Gourd, Brinjal, Cabbage, Cauliflower, 
--           Chickpea, Chilli, Cotton, Cucumber, Garlic, Groundnut, Guava, 
--           Maize, Mango, Muskmelon, Mustard, Okra, Onion, Papaya, Pigeon Pea, 
--           Pomegranate, Potato, Rice, Soybean, Sugarcane, Tomato, Turmeric, 
--           Watermelon, Wheat, and 5 more

-- 5. Check RLS policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd 
FROM pg_policies 
WHERE tablename = 'cropdata';
-- Expected: Should show "Allow public read" policy

-- 6. Test actual data fetch (what your Flutter app does)
SELECT "ID", "Crop", "Stage", "Timing" 
FROM public.cropdata 
WHERE "Crop" = 'Rice'
ORDER BY "ID"
LIMIT 5;
-- Expected: Should return 5 Rice stages

-- 7. Check table structure
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'cropdata' 
ORDER BY ordinal_position;
-- Expected: ID, Crop, Stage, Timing, Practice, Fertilizer/Action, Notes, created_at

-- ============================================
-- If ANY of these queries fail or return unexpected results,
-- you need to run CROPDATA_COMPLETE_SETUP.sql first!
-- ============================================
