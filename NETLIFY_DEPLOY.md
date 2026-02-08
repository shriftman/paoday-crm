# Netlify Deployment Guide - Paoday CRM

## 🚀 One-Click Deployment

**Click to deploy immediately:**
[![Deploy to Netlify](https://www.netlify.com/img/deploy/button.svg)](https://app.netlify.com/start/deploy?repository=https://github.com/shriftman/paoday-crm)

**Direct Deploy URL:**
```
https://app.netlify.com/start/deploy?repository=https://github.com/shriftman/paoday-crm
```

## 📋 Pre-Setup Checklist

Before deploying, ensure you have:

### Required Environment Variables:
1. **NEXT_PUBLIC_SUPABASE_URL** - Your Supabase project URL
2. **NEXT_PUBLIC_SUPABASE_ANON_KEY** - Your Supabase anonymous key
3. **OPENROUTER_API_KEY** - Your OpenRouter API key
4. **NEXT_PUBLIC_APP_URL** - Your custom domain (for production)
5. **NEXTAUTH_URL** - Your NextAuth URL (match your domain)

### Example values:
```
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-from-supabase-dashboard
OPENROUTER_API_KEY=sk-or-v1-your-openrouter-key
NEXT_PUBLIC_APP_URL=https://your-site.netlify.app
NEXTAUTH_URL=https://your-site.netlify.app
```

## 🔧 Manual Setup (Alternative)

If you prefer manual setup:

1. **Clone and push to your own repo:**
   ```bash
   git clone https://github.com/shriftman/paoday-crm.git
   cd paoday-crm
   git remote set-url origin YOUR_GITHUB_URL
   git push -u origin main
   ```

2. **Connect to Netlify:**
   ```bash
   npm install -g netlify-cli
   netlify login
   netlify deploy --prod
   ```

## 🎯 Netlify Free Tier Optimizations

### ✅ Already configured:
- **Static optimization** - Reduced runtime functions
- **Image optimization disabled** - Lower bandwidth usage
- **Caching headers** - Better performance
- **Compression enabled** - Reduced transfer size
- **Minimal dependencies** - Faster builds

### ⚡ Build settings:
- **Build command:** `npm run build`
- **Publish directory:** `.next`
- **Node version:** 18.x
- **Build time:** ~60-120 seconds

### 📊 Free tier limits (respected):
- **Bandwidth:** 100GB/month
- **Build minutes:** 300/month
- **Concurrent builds:** 1
- **Functions runtime:** 125ms

## 🐛 Troubleshooting

### Common issues and solutions:

1. **Build fails with "Module not found":**
   - Run `npm install` locally
   - Check package.json dependencies
   - Clear Netlify cache & retry

2. **Environment variables not loading:**
   - Verify variable names match exactly
   - No quotes in env values
   - Redeploy after changes

3. **Supabase connection issues:**
   - Ensure URL format is correct
   - Check CORS settings in Supabase
   - Verify anon key is valid

4. **Images not loading:**
   - Images are configured for static serving
   - Check image URLs in Supabase storage
   - Verify domain allowlists

## 🔄 Updates and Maintenance

### To update your deployment:
1. Push changes to your repository
2. Netlify automatically triggers new build
3. Site updates in ~1-2 minutes

### Build optimizations:
```bash
# Check build size locally
npm run build
npm run export
ls -la .next/
```

## 🎯 Success Checklist

After deployment, verify:
- [ ] Environment variables configured correctly
- [ ] Site loads without errors
- [ ] Supabase authentication works
- [ ] API routes function properly
- [ ] Images display correctly
- [ ] No console errors in browser dev tools

## 🔗 Live Examples

**Your site will be available at:**
- `https://[your-site-name].netlify.app`
- Custom domain support available

## 📞 Support

For deployment issues:
1. Check Netlify deploy logs
2. Verify environment variables
3. Test locally with `npm run build`
4. Ensure all dependencies are committed