namespace distortion
{
    partial class Form1
    {
        /// <summary>
        /// 必要なデザイナー変数です。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 使用中のリソースをすべてクリーンアップします。
        /// </summary>
        /// <param name="disposing">マネージ リソースが破棄される場合 true、破棄されない場合は false です。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows フォーム デザイナーで生成されたコード

        /// <summary>
        /// デザイナー サポートに必要なメソッドです。このメソッドの内容を
        /// コード エディターで変更しないでください。
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.panel2 = new System.Windows.Forms.Panel();
            this.pictureBoxTestSource = new System.Windows.Forms.PictureBox();
            this.panel1 = new System.Windows.Forms.Panel();
            this.pictureBoxDistortionTexture = new System.Windows.Forms.PictureBox();
            this.panel3 = new System.Windows.Forms.Panel();
            this.pictureBoxTestDist = new System.Windows.Forms.PictureBox();
            this.buttonLoadTest = new System.Windows.Forms.Button();
            this.buttonSave = new System.Windows.Forms.Button();
            this.buttonLoadDistortion = new System.Windows.Forms.Button();
            this.errorProvider1 = new System.Windows.Forms.ErrorProvider(this.components);
            this.ScrollBarMag = new System.Windows.Forms.HScrollBar();
            this.buttonTest = new System.Windows.Forms.Button();
            this.hScrollBarRadius = new System.Windows.Forms.HScrollBar();
            this.panel2.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxTestSource)).BeginInit();
            this.panel1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxDistortionTexture)).BeginInit();
            this.panel3.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxTestDist)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider1)).BeginInit();
            this.SuspendLayout();
            // 
            // panel2
            // 
            this.panel2.Controls.Add(this.pictureBoxTestSource);
            this.panel2.Location = new System.Drawing.Point(12, 12);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(260, 260);
            this.panel2.TabIndex = 2;
            // 
            // pictureBoxTestSource
            // 
            this.pictureBoxTestSource.Location = new System.Drawing.Point(2, 2);
            this.pictureBoxTestSource.Name = "pictureBoxTestSource";
            this.pictureBoxTestSource.Size = new System.Drawing.Size(256, 256);
            this.pictureBoxTestSource.TabIndex = 0;
            this.pictureBoxTestSource.TabStop = false;
            this.pictureBoxTestSource.Paint += new System.Windows.Forms.PaintEventHandler(this.pictureBoxTestSource_Paint);
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.pictureBoxDistortionTexture);
            this.panel1.Location = new System.Drawing.Point(278, 12);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(260, 260);
            this.panel1.TabIndex = 3;
            // 
            // pictureBoxDistortionTexture
            // 
            this.pictureBoxDistortionTexture.Location = new System.Drawing.Point(2, 2);
            this.pictureBoxDistortionTexture.Name = "pictureBoxDistortionTexture";
            this.pictureBoxDistortionTexture.Size = new System.Drawing.Size(256, 256);
            this.pictureBoxDistortionTexture.TabIndex = 0;
            this.pictureBoxDistortionTexture.TabStop = false;
            this.pictureBoxDistortionTexture.Click += new System.EventHandler(this.pictureBoxDistortionTexture_Click);
            this.pictureBoxDistortionTexture.Paint += new System.Windows.Forms.PaintEventHandler(this.pictureBoxDistortionTexture_Paint);
            // 
            // panel3
            // 
            this.panel3.Controls.Add(this.pictureBoxTestDist);
            this.panel3.Location = new System.Drawing.Point(544, 14);
            this.panel3.Name = "panel3";
            this.panel3.Size = new System.Drawing.Size(260, 260);
            this.panel3.TabIndex = 3;
            // 
            // pictureBoxTestDist
            // 
            this.pictureBoxTestDist.Location = new System.Drawing.Point(2, 2);
            this.pictureBoxTestDist.Name = "pictureBoxTestDist";
            this.pictureBoxTestDist.Size = new System.Drawing.Size(256, 256);
            this.pictureBoxTestDist.TabIndex = 0;
            this.pictureBoxTestDist.TabStop = false;
            this.pictureBoxTestDist.Paint += new System.Windows.Forms.PaintEventHandler(this.pictureBoxTestDist_Paint);
            // 
            // buttonLoadTest
            // 
            this.buttonLoadTest.Location = new System.Drawing.Point(14, 278);
            this.buttonLoadTest.Name = "buttonLoadTest";
            this.buttonLoadTest.Size = new System.Drawing.Size(75, 23);
            this.buttonLoadTest.TabIndex = 4;
            this.buttonLoadTest.Text = "ロード";
            this.buttonLoadTest.UseVisualStyleBackColor = true;
            this.buttonLoadTest.Click += new System.EventHandler(this.buttonLoadTest_Click);
            // 
            // buttonSave
            // 
            this.buttonSave.Location = new System.Drawing.Point(370, 278);
            this.buttonSave.Name = "buttonSave";
            this.buttonSave.Size = new System.Drawing.Size(75, 23);
            this.buttonSave.TabIndex = 5;
            this.buttonSave.Text = "セーブ";
            this.buttonSave.UseVisualStyleBackColor = true;
            // 
            // buttonLoadDistortion
            // 
            this.buttonLoadDistortion.Location = new System.Drawing.Point(289, 278);
            this.buttonLoadDistortion.Name = "buttonLoadDistortion";
            this.buttonLoadDistortion.Size = new System.Drawing.Size(75, 23);
            this.buttonLoadDistortion.TabIndex = 6;
            this.buttonLoadDistortion.Text = "ロード";
            this.buttonLoadDistortion.UseVisualStyleBackColor = true;
            this.buttonLoadDistortion.Click += new System.EventHandler(this.buttonLoadDistortion_Click);
            // 
            // errorProvider1
            // 
            this.errorProvider1.ContainerControl = this;
            // 
            // ScrollBarMag
            // 
            this.ScrollBarMag.Location = new System.Drawing.Point(289, 329);
            this.ScrollBarMag.Name = "ScrollBarMag";
            this.ScrollBarMag.Size = new System.Drawing.Size(220, 17);
            this.ScrollBarMag.TabIndex = 7;
            this.ScrollBarMag.Scroll += new System.Windows.Forms.ScrollEventHandler(this.hScrollBarMag_Scroll);
            this.ScrollBarMag.ValueChanged += new System.EventHandler(this.hScrollBarMag_ValueChanged);
            // 
            // buttonTest
            // 
            this.buttonTest.Location = new System.Drawing.Point(289, 407);
            this.buttonTest.Name = "buttonTest";
            this.buttonTest.Size = new System.Drawing.Size(75, 23);
            this.buttonTest.TabIndex = 8;
            this.buttonTest.Text = "buttonTest";
            this.buttonTest.UseVisualStyleBackColor = true;
            this.buttonTest.Click += new System.EventHandler(this.buttonTest_Click);
            // 
            // hScrollBarRadius
            // 
            this.hScrollBarRadius.Location = new System.Drawing.Point(289, 375);
            this.hScrollBarRadius.Name = "hScrollBarRadius";
            this.hScrollBarRadius.Size = new System.Drawing.Size(220, 17);
            this.hScrollBarRadius.TabIndex = 9;
            this.hScrollBarRadius.Scroll += new System.Windows.Forms.ScrollEventHandler(this.hScrollBarRadius_Scroll);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(817, 442);
            this.Controls.Add(this.hScrollBarRadius);
            this.Controls.Add(this.buttonTest);
            this.Controls.Add(this.ScrollBarMag);
            this.Controls.Add(this.buttonLoadDistortion);
            this.Controls.Add(this.buttonSave);
            this.Controls.Add(this.buttonLoadTest);
            this.Controls.Add(this.panel3);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.panel2);
            this.Name = "Form1";
            this.Text = "Form1";
            this.panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxTestSource)).EndInit();
            this.panel1.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxDistortionTexture)).EndInit();
            this.panel3.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxTestDist)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider1)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.PictureBox pictureBoxTestSource;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.PictureBox pictureBoxDistortionTexture;
        private System.Windows.Forms.Panel panel3;
        private System.Windows.Forms.PictureBox pictureBoxTestDist;
        private System.Windows.Forms.Button buttonLoadTest;
        private System.Windows.Forms.Button buttonSave;
        private System.Windows.Forms.Button buttonLoadDistortion;
        private System.Windows.Forms.ErrorProvider errorProvider1;
        private System.Windows.Forms.HScrollBar ScrollBarMag;
        private System.Windows.Forms.Button buttonTest;
        private System.Windows.Forms.HScrollBar hScrollBarRadius;
    }
}

