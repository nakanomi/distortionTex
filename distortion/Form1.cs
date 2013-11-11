using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace distortion
{
    public partial class Form1 : Form
    {
        Bitmap bmpTestSource = null;
        Bitmap bmpDistortionTex = null;
        Bitmap bmpTestDest = null;
        bool isBusy = false;
        float mMag = 5.0f;
        Point mPosCenter = new Point();
        float mRadius = 64.0f;

        float mCenterVal = 128.0f;
        float mMaxVal = 255.0f;

        public Form1()
        {
            InitializeComponent();
            {
                bmpDistortionTex = new Bitmap(pictureBoxDistortionTexture.Width, pictureBoxDistortionTexture.Height);
                bmpTestDest = new Bitmap(pictureBoxTestDist.Width, pictureBoxTestDist.Height);
                mPosCenter.X = pictureBoxDistortionTexture.Width / 2;
                mPosCenter.Y = pictureBoxDistortionTexture.Height / 2;
            }
        }
        #region Paint
        private void pictureBoxTestSource_Paint(object sender, PaintEventArgs e)
        {
            if (bmpTestSource != null)
            {
                Graphics gr = e.Graphics;
                gr.DrawImage(bmpTestSource,
                    0, 0, new Rectangle(0, 0, pictureBoxTestSource.Width, pictureBoxTestSource.Height),
                    GraphicsUnit.Pixel);
            }
        }


        private void pictureBoxDistortionTexture_Paint(object sender, PaintEventArgs e)
        {
            if (bmpDistortionTex != null)
            {
                Graphics gr = e.Graphics;
                gr.DrawImage(bmpDistortionTex,
                    0, 0, new Rectangle(0, 0, pictureBoxDistortionTexture.Width, pictureBoxDistortionTexture.Height),
                    GraphicsUnit.Pixel);
            }

        }

        private void pictureBoxTestDist_Paint(object sender, PaintEventArgs e)
        {
            if (
                (bmpTestDest != null) &&
                (bmpDistortionTex != null) &&
                (bmpTestSource != null)
                )
            {
                isBusy = true;
                for (int y = 0; y < bmpTestDest.Height; y++)
                {
                    for (int x = 0; x < bmpTestDest.Width; x++)
                    {
                        Color col = bmpDistortionTex.GetPixel(x, y);
                        if (col.A == 0)
                        {
                            bmpTestDest.SetPixel(x, y, bmpTestSource.GetPixel(x, y));
                        }
                        else
                        {

                            float xOffset = (float)col.R;
                            xOffset -= mCenterVal;
                            xOffset /= mMaxVal;
                            xOffset *= mMag;
                            int xVal = (int)(xOffset + (float)x);

                            float yOffset = (float)col.G;
                            yOffset -= mCenterVal;
                            yOffset /= mMaxVal;
                            yOffset *= mMag;
                            int yVal = (int)(yOffset + (float)y);

                            bmpTestDest.SetPixel(x, y, bmpTestSource.GetPixel(xVal, yVal));

                        }
                    }
                }
                Graphics gr = e.Graphics;
                gr.DrawImage(bmpTestDest, 0, 0,
                    new Rectangle(0, 0, pictureBoxTestDist.Width, pictureBoxTestDist.Height),
                    GraphicsUnit.Pixel);
                isBusy = false;
            }
        }
        #endregion

        private void pictureBoxDistortionTexture_Click(object sender, EventArgs e)
        {
            Console.WriteLine("aaa");
        }
        #region Buttons

        private void buttonLoadTest_Click(object sender, EventArgs e)
        {
            OpenFileDialog dlg = new OpenFileDialog();
            if (dlg.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                bmpTestSource = new Bitmap(dlg.FileName);
                pictureBoxTestSource.Invalidate();
            }
        }

        private void buttonLoadDistortion_Click(object sender, EventArgs e)
        {
            OpenFileDialog dlg = new OpenFileDialog();
            if (dlg.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                bmpDistortionTex = new Bitmap(dlg.FileName);
                pictureBoxDistortionTexture.Invalidate();
                pictureBoxTestDist.Invalidate();
            }
        }
        private void buttonTest_Click(object sender, EventArgs e)
        {
            drawCircle();
            pictureBoxTestDist.Invalidate();
            pictureBoxDistortionTexture.Invalidate();
        }
        #endregion

        private void drawCircle()
        {
            if (bmpDistortionTex != null) {
                Graphics gr = Graphics.FromImage(bmpDistortionTex);
                SolidBrush brushClear = new SolidBrush(Color.FromArgb((int)mMaxVal, (int)mCenterVal, (int)mCenterVal, (int)mCenterVal));
                gr.FillRectangle(brushClear, new Rectangle(0, 0, bmpDistortionTex.Width, bmpDistortionTex.Height));
                int xStart = mPosCenter.X - (int)mRadius;
                xStart = Math.Max(0, xStart);
                int yStart = mPosCenter.Y - (int)mRadius;
                yStart = Math.Max(0, yStart);
                int xEnd = mPosCenter.X + (int)mRadius;
                xEnd = Math.Min(xEnd, bmpDistortionTex.Width);
                int yEnd = mPosCenter.Y + (int)mRadius;
                yEnd = Math.Min(yEnd, bmpDistortionTex.Height);
                Point posCur = new Point();
                for (int y = yStart; y < yEnd; y++)
                {
                    for (int x = xStart; x < xEnd; x++)
                    {
                        posCur.X = x;
                        posCur.Y = y;
                        Point vOffset = Point.Subtract(posCur, new Size(mPosCenter));
                        float dist = ((float)vOffset.X * (float)vOffset.X) + ((float)vOffset.Y * (float)vOffset.Y);
                        dist = (float)Math.Sqrt(dist);
                        if (dist < mRadius)
                        {
                            float tmp = dist / mRadius;
                            tmp *= mMaxVal;
                            bmpDistortionTex.SetPixel(x, y, Color.FromArgb((int)tmp, 0, 0));
                        }
                    }
                }

            }
        }

        private void hScrollBarMag_ValueChanged(object sender, EventArgs e)
        {
            //Console.WriteLine("bbb");
        }

        private void hScrollBarMag_Scroll(object sender, ScrollEventArgs e)
        {
            if (!isBusy)
            {
                mMag = (float)((float)e.NewValue * 0.4);
                pictureBoxTestDist.Invalidate();
            }
        }

        private void hScrollBarRadius_Scroll(object sender, ScrollEventArgs e)
        {
            float minRadius = 32.0f;
            mRadius = (float)(e.NewValue) + minRadius;
            Console.WriteLine(mRadius);
        }

    }
}
